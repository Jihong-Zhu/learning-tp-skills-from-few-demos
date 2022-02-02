# Learning Task-Parameterzied Skills from Few Demonstrations

## Description

A basic MATLAB implementation of our RAL/ICRA paper:

Jihong Zhu, Michael Gienger, and Jens Kober. [Learning Task-Parameterized Skills from Few Demonstrations](https://arxiv.org/pdf/2201.09975.pdf).

[./m_fcts](./m_fcts) folder contains key functions extracted from [PbDlib](https://gitlab.idiap.ch/rli/pbdlib-matlab/). (MATLAB version)

[./additional_fcts](./additional_fcts) contains functions to implement Alg. 1 described in the paper.

### Dependencies

* Require MATLAB (v 2021b)

### Executing program

In the MATLAB console run:
```
RF_n_Noise.m
```
The code corresponds to the **RF + Noise** method in the paper. The code can be modified to run **RF** method easily.

The code was written and tested on MATLAB 2021b in Ubuntu 18.04

## Author
[Jihong Zhu](https://jihong-zhu.github.io/)

## Acknowledgement
This work was supported by Honda Research Institute Europe GmbH as part of the project: [Learning Physical Human-Robot Cooperation Tasks](http://www.jenskober.de/project_lphrct.php).

## License

This project is licensed under the [GNU GENERAL PUBLIC LICENSE] - see the LICENSE file for details
