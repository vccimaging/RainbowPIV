# RainbowPIV

Source code for "Rainbow Particle Imaging Velocimetry for Dense 3D Fluid Velocity Imaging"

#### Author:

JINHUI XIONG, RAMZI IDOUGHI, ANDRES A. AGUIRRE-PABLO, ABDULRAHMAN B. ALJEDAANI, XIONG DUN, QIANG FU, SIGURDUR T. THORODDSEN, and WOLFGANG HEIDRICH

#### Testing code:

Just download and run mainProgram.m. The source code is tested on Windows machine (Windows 7 with MATLAB R2015a). The output figure is the flow vector visualization at one time step (corresponding to FIG. 10 in the paper). In order to save computation time and memory, you can set numFrame as 2 or 3.

#### Other datasets:

This package only contains 6 frames for one vortex structure. If you are interested in more frames or the other datasets, please contact the author by email (jinhui.xiong@kaust.edu.sa).

#### Memory Requirement:

For the provided dataset, it requires about 20 GB memory at the peak, and 7GB memory at stable condition for 6 frames to be processed simultaneously. (Note: As I found, line 15 (A_re = kron(speye(numFrame),A)) in estimatePosition.m costs additional memory, other ways can be adopted to implement the same function in case of lack of memory)

#### Acknowledgment:

Thanks to Stephen Boyd for his publice source code on site: https://web.stanford.edu/~boyd/papers/admm/
Thanks to Enric Meinhardt-Llopis for his publice source code on site: http://www.ipol.im/pub/art/2013/20/?utm_source=doi

#### Reference:

Jinhui Xiong, Ramzi Idoughi, Andres A. Aguirre-Pablo, Abdulrahman B. Aljedaani, Xiong Dun, Qiang Fu, Sigurdur T. Thoroddsen, and Wolfgang Heidrich. 2017. Rainbow Particle Imaging Velocimetry for Dense 3D Fluid Velocity Imaging. ACM Trans. Graph. 36, 4

If you find any bugs or have comments/questions, please contact Jinhui Xiong at jinhui.xiong@kaust.edu.sa.
