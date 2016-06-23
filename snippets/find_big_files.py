#!/usr/bin/env python
# Copyright (c) 2006, Eric Breck
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
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

"""
Find the files or directories taking up the most disk space

This program prints out any file or subdirectories whose contents take up more
than 'bigsize' bytes (0.5 GB by default), not counting any sub-nodes which are
themselves big.  By default the search starts at the user's home directory, but
this can be changed with the -r/--root option.

$Revision: 1.4 $
"""

import sys, optparse, os, os.path, math

def getsize(node,bigsize):
  try:
    st=os.lstat(node)
    total_file_size = st.st_size
    if hasattr(st,'st_blocks'):
      # I'm not sure this is the right interpretation of st_blocks, but
      # some testing on several systems suggests that st_blocks * st_blksize is
      # NOT the right way to get total on-disk space
      #
      # FWIW, Linus agrees... http://www.uwsg.indiana.edu/hypermail/linux/kernel/0409.3/0438.html
      total_on_disk_size = st.st_blocks*512
    else:
      # this is an underestimate if st_blocks is unavailable
      total_on_disk_size = total_file_size
    if os.path.islink(node):
      return total_on_disk_size, total_file_size
    if os.path.isdir(node):
      if not os.access(node,os.R_OK | os.X_OK):
        print >> sys.stderr,'unable to access directory',node
      else:
        for child in os.listdir(node):
          childpath = os.path.join(node,child)
          disk_size, file_size = getsize(childpath,bigsize)
          if disk_size > bigsize:
            print sizestr(disk_size), sizestr(disk_size - file_size), childpath
          else:
            total_on_disk_size += disk_size
            total_file_size += file_size
    return total_on_disk_size, total_file_size
  except OSError,o:
    print >> sys.stderr,'error accessing path',node,o.strerror
    return 0, 0

def sigfig(n):
  '''= n with at least 3 significant figures'''
  if n <= 0: d = 10
  else: d=int(math.floor(math.log(n)/math.log(10)))
  return '%5.*f' % (max(0,2-d),n)

def sizestr(size):
  if size < 2**10: return ' '+sigfig(float(size))
  elif size < 2**20: return sigfig(float(size)/(2**10))+'k'
  elif size < 2**30: return sigfig(float(size)/(2**20))+'m'
  elif size < 2**40: return sigfig(float(size)/(2**30))+'g'
  else: return str(size)

def main (options,args):
  if len(args) == 0: root = os.environ['HOME']
  else: root = args[0]
  print '  disk  slack file/directory'
  disk_size, file_size =getsize(root,options.bigsize*(2**20))
  print sizestr(disk_size), sizestr(disk_size - file_size), root

if __name__=='__main__':
  p = optparse.OptionParser('usage: %prog [-b BIGSIZE] [directory]')
  p.add_option('-b','--bigsize',default=512,type='float',help='what counts as big (in megabytes: default 512)')
  options,args = p.parse_args()
  main(options,args)
