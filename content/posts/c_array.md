---
title: "C语言：数组"
date: 2023-03-25T09:30:00+08:00
tags: ["C语言","数组"]
description: "Desc Text."
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
---
### 基本操作

- `&`取址操作符
- `*`取值操作符
- 数组名指向数组的第一个元素的地址。
- **不要解引用未初始化的指针**

### 1.初始化

如果数组未初始化，那么数组中的元素会使用“垃圾值”来填充。如果手动初始化了部分数组元素，那么剩余未初始化的元素会用类型的默认值来填充。
C语言不允许把数组作为一个单元赋值给另一个数组(*可以使用指针*)

```c
char arr_1[5] = {'A','B','C','D','E'};
char arr_2[5];
arr_2 = arr_1;  		// 错误，不允许
char* arr_3 = arr_1; 	// 正确，允许
```

### 2.数组边界

使用数组时，要防止数组下标超出边界，必须保证下标是有效值。C编译器一般不会检查数组下标越界的问题，也不会报错。

>  在声明数组时使用符号常量来表示数组大小，以保证整个程序中的数组大小始终一致

### 3.指针和数组

- 一个数组名就是数组第一个元素的地址。即：

```c
char arr[4] = {'A','B','C','D'}
arr == &arr[0];
// 或者
printf("%p",&arr);
printf("%p",&arr[0])
// 打印的值一样
```

- 数组首元素的内存地址都是常量，在程序运行过程中不会被改变，但是可以将地址赋值给变量，然后再修改指针变量的值。
> 在系统中，地址按字节编址。short占两字节，double占四字节，在C中，指针加1指的是增加一个存储单元，而不是指向下一个字节。
>
> 这是为什么必须声明指针所指向对象类型的原因之一，只知道地址是不够的，因为计算机要知道储存对象需要多少字节。

short类型指针+1，代表地址+2；double类型指针+1，代表地址+4；如果只知道地址而不知道变量类型，那么指针就无法正确获取元素的地址。

C语言指针和数组的灵活性

```c
arr+2 = &arr[2];
*(arr+2) = arr[2];
```

`*(arr+2)`的含义可以表述为：**在内存`arr`的位置，移动2个单元，再获取储存在哪里的值**

## 函数、数组、指针

### 1.指针形参

一个处理数组的函数，其形参应该是一个指向特定类型的指针。

```c
// 求数组中的元素之和
int sum(int* arr);
```

`sum`函数获得了`arr`的地址，并以`arr`首元素的地址为起始地址查找一串整数。但是`sum`函数并不知道数组的元素个数，所以可以在第二个形参中，接受一个表示数组长度的参数。

```c
int sum(int* arr,int len);
```

如果形参要求是一个与数组相匹配的指针，那么下面这两种声明方式是等价的。

```c
int sum(int* arr, int len);
int sum(int arr[], int len);
```

**系统使用8字节存储地址，所以指针变量的大小是8字节。**

### 2.使用指针形参

> 函数处理数组要知道何时开始、何时结束。

另一种方法是，使用双指针，标记数组的其实和开始的位置。

```c
int sump(int* start, int* end)
{
    int total = 0;
    while(start < end)
    {
        total+=*start;
        start++;
    }
    return total
}
```

```c
// 调用
#define SIZE 10
int arr[SIZE] = { ... }
sump(arr, arr + SIZE);
```

数组的下标从0开始，其中`end = arr + SIZE`，其指向数组末尾元素的下一个位置。所以不会产生数组越界问题。

### 3.指针表示法、数组表示法

> 处理数组的函数实际上是用指针作为参数的，但是在编写函数时，可以选择形参是以数组的形式表示还是指针的形式表示。

### 4.指针操作

*解引用*：*运算符给出指针指向地址上的存储的值。

> 创建一个指针时，系统只分配了储存指针本身的内存，并未分配储存数据的内存。因此，在使用指针之前，必须先用已分配的地址初始化它。
```c
int* ptr;
*ptr = 5; // 错误
```
指针若只被创建但未初始化，其地址值是一个随机值，将5赋值给该指针，并不知道5存储在何处。

**注意：不要解引用未初始化的指针**

### 5.保护数组中的数据

如果不希望在函数内部改变原始数据的值，需要在形参加上`const`关键字。此处的`const`的意思不是*常量*，而是表示函数在处理数组时将实参当错常量来处理，一旦代码试图对实参的数据进行修改，那么编译器会报*编译错误*。

```c
int sum(const int arr[],int n);
```

const可用于创建const数组、const指针以及指向const的指针。
