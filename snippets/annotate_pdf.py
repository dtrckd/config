#!/usr/bin/env python
# Copyright (c) 2007, Eric Breck
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1 Redistributions of source code must retain the above copyright notice, this
#   list of conditions and the following disclaimer.
#
# 2 Redistributions in binary form must reproduce the above copyright notice,
#   this list of conditions and the following disclaimer in the documentation
#   and/or other materials provided with the distribution.
#
# 3 The name of the author may not be used to endorse or promote products
#   derived from this software without specific prior written permission.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
# ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
# LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
# CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
# SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
# INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
# CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
# ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
# POSSIBILITY OF SUCH DAMAGE.

"""
Annotate a PDF file with text in the left margin
Usage: annotate_pdf.py -m 'string-to-add' input.pdf output.pdf

Requires python 2.3 or greater
May not work with PDF-1.5 or greater (cross-reference streams in particular)

Author: Eric J. Breck
$Revision: 1.5 $
"""

import sys, optparse, re, shutil

def readstream(f):
  '''Effect: advance PDF file pointer to the end of the next stream
     Returns: length of stream (not counting start/end markers)'''
  streamstart=f.tell()
  prevblock=''
  while 1:
    block=f.read(1024)
    if block == '':
      raise 'Error, stream not ended'
    m=re.search(r'endstream[\r\n]*',prevblock+block)
    if m is not None:
      f.seek(m.end()-len(prevblock+block),1)
      return f.tell()-len(m.group())-streamstart
    prevblock=block

rx = re.compile(r'%[^\r\n]*[\r\n]+|\s+|(\((?:[^()\\]|\\.)*\)|<[0-9a-fA-F]+>|\d+\.\d+|\d+|<<|>>|/[\w.+-]+|\[|\]|stream(?:\r\n|\n)|\w+)')
def gentokens(f):
  '''yield PDF tokens; a stream is yielded as a single object'''
  buffer=''
  pos=0
  while 1:
    m = rx.search(buffer,pos)
    if m is None or m.end()==len(buffer):
      next = f.read(1024)
      buffer=buffer[pos:]+ next
      if buffer=='':
        return
      if next == '':
        # FIXME: shouldn't yield buffer, should yield m...
        yield buffer
        return
      pos=0
    else:
      token = m.group(1)
      pos = m.end()
      if token is not None:
        if token[:6]=='stream':
          f.seek(-pos,1)
          yield PDFStream(readstream(f))
          pos=0
          buffer=''
        else:
          yield token

# replace nonprinting characters with .
def clean(s): return re.sub(r'[\000-\037\177-\377]','.',s)

class PDFObject:
  def lookup(self,f,xref):
    return self

class PDFDict(PDFObject):
  '''PDFDict represents a <<..>> PDF dictionary.  Access is as if the
     dictionary keys were fields of this object; i.e. to get key /Type from
     PDFDict d, use d.Type'''
  def __init__(self,list):
    if len(list) % 2 != 0:
      raise "making dictionary from odd-sized list"
    for i in range(len(list)/2):
      self.__dict__[list[2*i].token[1:]]=list[2*i+1] # 1: to remove initial /
  def __str__(self):
    ret = '<<\n'
    for key, value in self.__dict__.items():
      if key[:2]!='__':
        ret += '  /%s %s\n' % (key,value)
    return ret + '>>'

class PDFArray(PDFObject):
  def __init__(self,list):
    self.list=list[:]
  def __str__(self):
    return '[%s]' % (' '.join(map(str,self.list)))

class PDFReference(PDFObject):
  def __init__(self,num,gen):
    self.num=int(num)
    self.gen=int(gen)
  def __str__(self):
    return '%d %d R' % (self.num,self.gen)
  def _lookup(self,f,xref):
    position = xref[self.num]
    f.seek(position)
    return parsePDFobject(f)
  def lookup(self,f,xref):
    return self._lookup(f,xref).contents[0]

class PDFIndirectObject(PDFObject):
  def __init__(self,num,gen,contents):
    self.num=int(num)
    self.gen=int(gen)
    self.contents=contents
  def ref(self): return PDFReference(self.num,self.gen)
  def __str__(self):
    return '%d %d obj\n%s\nendobj' % (self.num,self.gen,' '.join(map(str,self.contents)))
  def write(self,xref,outf):
    xref[self.ref().num]=outf.tell()
    outf.write(str(self)+'\n')

class PDFToken(PDFObject):
  def __init__(self,token):
    self.token=token
  def __str__(self):
    return self.token
  def __int__(self):
    return int(self.token)

class PDFStream:
  def __init__(self,len):
    self.len=len
  def __str__(self):
    return 'stream(%s bytes)' % self.len

def parsePDFobject(f):
  '''at the current file position, parse PDF and return either one indirect
  object or one dictionary'''
  stack0=[]
  stack1=[]
  for token in gentokens(f):
    if isinstance(token,PDFStream):
      # FIXME: should pop dictionary off the stack and include in stream ...
      stack1.append(token)
    elif token=='obj':
      gen=stack1.pop()
      num=stack1.pop()
      stack1.append(PDFIndirectObject(num,gen,None))
      stack0.append(stack1)
      stack1=[]
    elif token=='endobj':
      contents=stack1
      stack1=stack0.pop()
      assert len(stack0)==0 and len(stack1)==1
      stack1[0].contents=contents
      return stack1[0]
    elif token == '<<':
      stack0.append(stack1)
      stack1=[]
    elif token == '>>':
      stack1=stack0.pop()+[PDFDict(stack1)]
      if len(stack0)==0 and len(stack1)==1:
        return stack1[0]
    elif token == '[':
      stack0.append(stack1)
      stack1=[]
    elif token == ']':
      stack1=stack0.pop()+[PDFArray(stack1)]
    elif token == 'R':
      gen=stack1.pop()
      num=stack1.pop()
      stack1.append(PDFReference(num,gen))
    else:
      stack1.append(PDFToken(token))
  print stack0
  print stack1
  raise 'parse failure'

def parsexref(f,startxref):
  'parse cross-reference part of PDF file; FIXME does not handle xref streams'
  f.seek(startxref)
  if f.readline()[:4] != 'xref':
    raise "parse error; no xref section found"
  xref={}
  while 1:
    line=f.readline()
    m=re.search(r'^(\d+) (\d+)',line)
    if m is None:
      while line[:7] != 'trailer': line=f.readline()
      f.seek(-(len(line)-7),1)
      trailer = parsePDFobject(f)
      if hasattr(trailer,'Prev'):
        oldxref, oldtrailer = parsexref(f,trailer.Prev)
        oldxref.update(xref)
        xref=oldxref
      return xref, trailer
    start, num = map(int,m.groups())
    for i in range(num):
      offset, generation, flag = f.readline().split()
      if flag == 'n':
        xref[start+i]=int(offset)

def makestream(stream,index):
  '''from a string 'stream', create a pdf indirect object number 'index' '''
  return PDFIndirectObject(index,0,[PDFDict([PDFToken('/Length'),str(len(stream))]),'\nstream\n%s\nendstream' % stream])

def parsetail(f):
  '''parse PDF trailer'''
  taillen=1024 # arbitrary; should be enough
  f.seek(-taillen,2) # seek to taillen bytes before file's end
  tail = f.read(taillen)

  p=tail.rfind('startxref')
  if p == -1: raise "Can't find startxref in PDF trailer!"
  # FIXME: the following could raise a couple of exceptions; raise parse error
  m=re.search(r'startxref[\r\n\s]+(\d+)[\r\n\s]+%%EOF',tail[p:])
  startxref=int(m.group(1))

  return startxref

def collectpages(pagelist,noderef,inf,xref):
  indobj = noderef._lookup(inf,xref)
  node = indobj.contents[0]
  type = str(node.Type)
  if type=='/Pages':
    for kidref in node.Kids.list:
      collectpages(pagelist,kidref,inf,xref)
  elif type=='/Page':
    pagelist.append(indobj)
  else:
    raise "invalid page tree node",node

def append_if_not_present(list,elt):
  '''The more straightforward 'if elt not in list' doesn't work if elts don't
     compare by 'is' '''
  not_there=True
  for t in list:
    if t==elt: not_there=False
  if not_there: list.append(elt)

def main(options, args, p):
  if options.print_tokens:
    f=open(args[0])
    for token in gentokens(f):
      print token
    return
  if len(args) !=2:
    p.print_usage()
    return
  infn, outfn = args
  inf = open(infn,'rUb')
  startxref = parsetail(inf)
  xref, trailer = parsexref(inf,startxref)
  pages = []
  collectpages(pages,trailer.Root.lookup(inf,xref).Pages,inf,xref)
  # PDF strings require ()\ to be escaped
#  message=options.message.replace('(',r'\(').replace(')',r'\)').replace('\\',r'\\')
  # FIXME... or maybe they don't?  Or only when parens don't balance?
  message=options.message
  size=int(trailer.Size)

  push=makestream('q',size) # push graphics state

  # Here's how the Tm command works:
  #
  # cos t sin t -sin t cos t x y Tm
  # rotates by t radians counterclockwise
  # and starts at x,y

  annotation=makestream('''Q
BT
  /annotatepdfFont 24 Tf
  0.5 g
  0 1 -1 0 30 50 Tm
  (%s) Tj
ET''' % message,size+1)

  newfont=PDFIndirectObject(size+2,0,
  [PDFDict([PDFToken(s) for s in (
   '/Type','/Font',
   '/Subtype','/Type1',
   '/Name','/annotatepdfFont',
   '/BaseFont','/Helvetica',
   '/Encoding','/MacRomanEncoding',)])])

  inf.close()
  shutil.copyfile(infn, outfn)

  inf = open(infn,'rb')
  outf = open(outfn,'ab')
  # now print appendix with new information
  outf.write('%% BEGIN annotate-pdf\n')
  newxref={}

  push.write(newxref,outf)
  annotation.write(newxref,outf)
  newfont.write(newxref,outf)

  for page in pages:
    contents = page.contents[0].Contents
    # if contents is a reference to an array, replace it by the array
    if isinstance(contents,PDFReference):
      c=contents.lookup(inf,xref)
      if isinstance(c,PDFArray): contents=c
    # create a new array of push + contents + annotation
    if isinstance(contents,PDFArray):
      array=[push.ref()]+contents.list+[annotation.ref()]
    else:
      assert(isinstance(contents,PDFReference))
      array=[push.ref(),contents,annotation.ref()]
    page.contents[0].Contents=PDFArray(array)
    resources=page.contents[0].Resources.lookup(inf,xref)

    procset=resources.ProcSet.lookup(inf,xref)
    append_if_not_present(procset.list,PDFToken('/PDF'))
    append_if_not_present(procset.list,PDFToken('/Text'))
    resources.ProcSet=procset

    if hasattr(resources,'Font'):
      font = resources.Font.lookup(inf,xref)
    else:
      font = PDFDict([])
    font.annotatepdfFont=newfont.ref()
    resources.Font=font

    page.contents[0].Resources=resources

    page.write(newxref,outf)

  newstartxref=outf.tell()
  outf.write('''xref
0 1
0000000000 65535 f \n''') # space after f is required by PDF format
  for num, pos in newxref.items():
    outf.write('%d 1\n' % num)
    outf.write('%010d 00000 n \n' % pos)
  trailer.Size=size+3 # added three new objects
  trailer.Prev=startxref
  outf.write('''trailer
%s
startxref
%s
%%%%EOF
''' % (trailer,newstartxref))

  inf.close()
  outf.close()

if __name__=='__main__':
  p = optparse.OptionParser(usage='%prog [-m MESSAGE] input.pdf output.pdf')
  p.add_option('-m','--message',default="Replace this with desired message")
  p.add_option('-t','--print_tokens',default=False,action='store_true',help="(for debugging use only)")
  options, args = p.parse_args()
  main(options, args, p)
