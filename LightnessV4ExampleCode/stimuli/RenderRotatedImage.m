function imData = RenderRotatedImage(imageData, rotationDeg, rotationAxis, screenDist, sceneDims, objectDims, bgVal)
% RenderRotatedImage - Rotates image data via OpenGL and returns the resulting image matrix.
%
% Syntax:
% imData = RenderRotatedImage(imageData, rotationDeg, rotationAxis, screenDist, sceneDims, objectDims)
%
% Description:
% Converts the image data to a texture object in OpenGL, rotates it, then
% returns the bitmap pixel data of the rendered scene.  The screen may go
% black for a few seconds while the pixels are being grabbed through OpenGL
% calls, and nothing will be displayed.
%
% Input:
% imageData (MxNx3) - The image data in the [0,1] range.
% rotationDeg (scalar) - The amount to rotate in degrees.
% rotationAxis (1x3) - The axis about which to rotate the image
%     counterclockwise.
% screenDist (scalar) - The distance from the camera to (0,0,0).
% sceneDims (1x2) - The width and height of the rendered scene at the z=0
%     plane.
% objectDims (1x2) - The width and height of the image texture object.
%
% Output:
% imageData (M'xN'x3) - The image data for the rotated image.

global MGL GL;

% Setup MOGL if it hasn't been.
if isempty(GL)
	InitializeMatlabOpenGL;
end

% Check the number of inputs.
error(nargchk(7, 7, nargin));

fprintf('- Rendering rotated image and grabbing pixel data (this is slow)...');

frustum = GLWindow.calculateFrustum(screenDist, sceneDims, 0);

try
	% Open the MGL window.
	mglOpen;
	
	% Create the texture from the image data.
	tex = mglCreateTexture(imageData*255);
	
	% Clear the screen and set the background color.
	bgColor = [bgVal bgVal bgVal];
	mglClearScreen(bgColor);
	
	% Setup the projection matrix.  The projection matrix defines how
	% the OpenGL coordinate system maps onto the physical screen.
	glMatrixMode(GL.PROJECTION);
	
	% This gives us a clean slate to work with.
	glLoadIdentity;
	
	% Map our 3D rendering space to the display given a specific
	% distance from the screen to the subject and an interocular
	% offset.  This is calculated at the beginning of the program.
	glFrustum(frustum.left, frustum.right, frustum.bottom, frustum.top, frustum.near, frustum.far);
	
	% Now we switch to the modelview mode, which is where we draw
	% stuff.
	glMatrixMode(GL.MODELVIEW);
	glLoadIdentity;
	
	% In 3D mode, we need to specify where the camera (the subject) is
	% in relation to the display.  Essentially, for proper stereo, the
	% camera will be placed at the screen distance facing straight
	% ahead not at (0,0).
	gluLookAt(0, 0, screenDist, ... % Eye position
		0, 0, 0, ...					   % Fixation center
		0, 1, 0);						   % Vector defining which way is up.
	
	% Rotate the texture and stick in the framebuffer.
	glRotated(rotationDeg, rotationAxis(1), rotationAxis(2), rotationAxis(3));
	mglBltTexture(tex, [0 0 objectDims(1) objectDims(2)]);
	
	% Grab the scene pixel data.
	pxData = double(mglFrameGrab);
	
	% Rotate the dumped pixels 90 degrees counter clockwise, otherwise the
	% image will be rotated wrong.
	imData = zeros(size(pxData, 2), size(pxData, 1), 3);
	for i = 1:size(pxData, 2)
		for j = 1:size(pxData, 1)
			imData(MGL.screenHeight-i+1, j, :) = pxData(j, i, :);
		end
	end
	
	% Flip the data upside down.  The MGL framegrab function is stupid and
	% does everything backwards.
	imData = flipdim(imData, 1);
	
	mglClose;
	
	fprintf('Done.\n');
catch e
	mglClose;
	rethrow(e);
end
