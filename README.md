# RainbowPIV

Source code for "Rainbow Particle Imaging Velocimetry for Dense 3D Fluid Velocity Imaging"

#### Author:

JINHUI XIONG, RAMZI IDOUGHI, ANDRES A. AGUIRRE-PABLO, ABDULRAHMAN B. ALJEDAANI, XIONG DUN, QIANG FU, SIGURDUR T. THORODDSEN, and WOLFGANG HEIDRICH

#### Testing code:

Just download and run mainProgram.m. The source code is tested on Windows machine (Windows 7 with MATLAB R2015a). The output figure is the flow vector visualization at one time step (the one of vortex dataset corresponding to FIG. 10 in the paper). In order to save computation time and memory, you can set numFrame as 2 or 3.

#### datasets:

This package contains datasets of vortex, jet, drop, and twoVortex, and each of them includes 20 frames. You can try different datasets by changing directory in readImage.m.

#### Memory Requirement:

For the provided dataset, the largest one requires about 20 GB memory at the peak, and 7GB memory at stable condition for 6 frames to be processed simultaneously. (Note: As I found, line 15 (A_re = kron(speye(numFrame),A)) in estimatePosition.m costs additional memory, other ways can be adopted to implement the same function in case of lack of memory)

#### Acknowledgment:

Thanks to Stephen Boyd for his publice source code on site: https://web.stanford.edu/~boyd/papers/admm/.
Thanks to Enric Meinhardt-Llopis for his publice source code on site: http://www.ipol.im/pub/art/2013/20/?utm_source=doi.

#### Reference:

```
@Article{Xiong:2017:RPIV,
  author =       {J. Xiong and R. Idoughi and A. Aguirre-Pablo and A. Aljedaani and X. Dun and Q. Fu and S. Thoroddsen and W. Heidrich},
  title =        {Rainbow Particle Imaging Velocimetry for Dense 3D Fluid Velocity Imaging},
  journal =      {ACM Transactions on Graphics (Proc. SIGGRAPH)},
  year =         2017,
  volume =       36,
  number =       4,
  month =        {July},
  pages =        {36:1--36:14}
}
```

If you find any bugs or have comments/questions, please contact Jinhui Xiong at jinhui.xiong@kaust.edu.sa.
