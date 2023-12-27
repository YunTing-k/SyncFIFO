## 项目简介
这是一个具有汉明码错误检测与矫正功能，并且具有8通道动态仲裁的读出，以及APB3协议控制的同步FIFO的HDL设计、Systemverilog验证的项目。旨在通过完善的设计、验证流程熟悉IC前端设计。是上海交通大学蒋剑飞老师课程SystemVerilog电路设计与验证(EST8703-039-M01)的LAB内容。更详细的文档请见[DOC](https://github.com/YunTing-k/SyncFIFO/tree/master/DOC)部分。

This is a sync FIFO with hanming code error dectecion and correction, 8-channel dynamic priority readout arbiter, APB3 control, which is a complete flow from HDL design to systemverilog verification. With this project, a complete flow is helpful to have a better understanding to IC front-end design. This project is the LAB of the course "SystemVerilog-Circuit Design and Verification" from Shanghai Jiao Tong University, Prof. Jiang Jianfei. More details please see the documents in [DOC](https://github.com/YunTing-k/SyncFIFO/tree/master/DOC) folder.

## 同步FIFO架构
![Sync FIFO Architecture](https://github.com/YunTing-k/SyncFIFO/blob/master/DOC/img/img1.png?raw=true)

## 同步FIFO设计文件例化关系
![Design Hierarchy](https://github.com/YunTing-k/SyncFIFO/blob/master/DOC/img/img3.png?raw=true)

## 基于SystemVerilog的验证框架
![SystemVerilog Verification Architecture](https://github.com/YunTing-k/SyncFIFO/blob/master/DOC/img/img2.png?raw=true)

## Note
- 在QuestaSim中运行具有assertion的工程时，请在QuestaSim的console输入如下参数：
```vsim -gui -assertdebug -novopt work.testbench_top```
其中```work.testbench_top```为所定义的仿真顶层module