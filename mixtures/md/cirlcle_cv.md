@cv
@python

view-source:http://txt.arboreus.com/2014/10/21/remove-circles-from-an-image-in-python.html

<div id="header" class="pure-menu pure-menu-open pure-menu-horizontal">

*   [<< contents](/ "*.txt")
*   [en](/tagged/en.html)
  *   [image-processing](/tagged/image-processing.html)
  *   [python](/tagged/python.html)
  *   [opencv](/tagged/opencv.html)
  *   [atom feed](/feed.atom)

  </div>

  <div id="content-wrapper">

  <div id="content">

  <div class="entry">

# Remove circles from an image in Python

  <span id="published-date">2014-10-21</span>

  This post is a follow-up to a post by _Steve on Image Processing_ on how to remove circles from an image by specifying their center and radius. Read [Filling circles](http://blogs.mathworks.com/steve/2014/07/31/filling-circles/) to see how to do it in Matlab. I'll show how to do it in Python with SciPy and OpenCV.

  Some initial imports we'll need:

      import cv2
          import numpy as np

          The starting point is an image with some circular objects:

          ![coins.png](/media/image/coins.png)

  To read this file as a grayscale image I do:

      img = cv2.imread("coins.png", cv2.IMREAD_GRAYSCALE)

      Let's hide the coin at `x=348`, `y=317` and radius 45 pixels. Similar to Matlab recipe, we create a mask first.

          # location and size of the circle
          xc, yc, r = 348, 317, 45
              # size of the image
              H, W = img.shape
                  # x and y coordinates per every pixel of the image
                  x, y = np.meshgrid(np.arange(W), np.arange(H))
      # squared distance from the center of the circle
      d2 = (x - xc)**2 + (y - yc)**2
          # mask is True inside of the circle
          mask = d2 < r**2

          ![coin-mask.png](/media/image/coin-mask.png)

  We may simply set image to black (`0`) or white (`255`) under the mask as in the Matlab recipe, or we may calculate an average color outside of the coin, and fill inner pixels with this color:

      outside = np.ma.masked_where(mask, img)
      average_color = outside.mean()
      img[mask] = average_color

      New image now looks like this:

      ![coin-masked.png](/media/image/coin-masked.png)

  The coin is missing, but the circle is clearly visible. A nicer way to fill the circle is to use OpenCV [`inpaint`](http://docs.opencv.org/modules/photo/doc/inpainting.html#inpaint) function. It will reconstruct the missing part from the pixels around it.

      # we need to convert the mask to 8bit single channel image
      bytemask = np.asarray(mask*255, dtype=np.uint8)
      inpainted = cv2.inpaint(img, bytemask, inpaintRadius=10, flags=cv2.INPAINT_TELEA)

  The inpainted image:

  ![coin-inpainted.png](/media/image/coin-inpainted.png)

  Now what if I wanted to find and remove all coins automatically? The approach suggested in Steve's article (apply binary threshold to mask all coins which _happen_ to be brighter than the background) will not work, unless I carefully select a different background and take care of uniform illumination.

  A different approach is to use [Hough transform](http://docs.opencv.org/modules/imgproc/doc/feature_detection.html#houghcircles) to detect circles:

      circles = cv2.HoughCircles(img, cv2.cv.CV_HOUGH_GRADIENT,
                                         dp=1.5, minDist=30, minRadius=15, maxRadius=60)

  Hough transform is somewhat finicky as far as parameters should be selected on a case-by-case basis. Beyond the parameters in the example above you may want to adjust two other parameters: `param1` (default value is 100), which more or less translates into sensitivity of the edge detection procedure (see [OpenCV docs](http://docs.opencv.org/modules/imgproc/doc/feature_detection.html#houghcircles) for a more techinal definition), and `param2` (default value is 100) is a circle detection threshold. The smaller is `param2`, the more false circles will be detected.

  To make sure only the right circles were selected we'll draw them over the original color image:

      color_img = cv2.imread("coins.png")
          red = (0,0,255)
      for x, y, r in circles[0]:
              cv2.circle(color_img, (x,y), r, red, 2)

  ![coins-detected.png](/media/image/coins-detected.png)

  The detected circles are not very precise, they don't cover shadow and reflex zone around the coin, so we may want to make them slightly bigger when creating a mask.

      black = np.zeros(img.shape)
      for x, y, r in circles[0]:
              cv2.circle(black, (x,y), int(r+15), 255, -1)  # -1 to draw filled circles

              ![coins-mask.png](/media/image/coins-mask.png)

  Now we may simply inpaint all found coins:

      bytemask = np.asarray(black, dtype=np.uint8)
      inpainted = cv2.inpaint(img, bytemask, inpaintRadius=5, flags=cv2.INPAINT_TELEA)

  And all coins magically disappear:

  ![coins-all-inpainted.png](/media/image/coins-all-inpainted.png)

  We used three OpenCV features:

  *   Hough transform
  *   `inpaint` function
  *   primitive drawing procedures (`cv2.circle`)

  If we skip inpainting, which is unique to OpenCV right now, we may also do everything in scikit-image. It tends to have a nicer Python interface. Let me know if you'd like to see some examples.

  If you like this post, you may also like [Counting objects and calculating objects' density in Python](/2012/12/20/counting-objects-and-calculating-objects-density-in.html).

  <div class="tags"><span class="tag">[en ](/tagged/en.html)</span><span class="tag">[image-processing ](/tagged/image-processing.html)</span><span class="tag">[python ](/tagged/python.html)</span><span class="tag">[opencv](/tagged/opencv.html)</span></div>

  <div id="feedback">[Comment](mailto:Sergey Astanin%20<txt@arboreus.com>?subject=%5B*.txt%5D%20Remove%20circles%20from%20an%20image%20in%20Python&body=%5BWrite%20your%20comment%20here%20and%20send%20me%20the%20message%5D)</div>

  </div>

  </div>

  </div>

  <script>hljs.initHighlightingOnLoad();</script>
