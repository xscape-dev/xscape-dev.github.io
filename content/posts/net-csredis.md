---
title: "在.NET中使用Redis"
date: 2023-03-26T20:51:41+08:00
tags: [".net","redis"]
description: "Desc Text."
cover:
    image: "<image path/url>" # image path/url
    alt: "<alt text>" # alt text
---
## 为什么选择CSRedis
1. ServiceStack.Redis 是商业版，免费版有限制；
2. StackExchange.Redis 是免费版，但是内核在 .NETCore 运行有问题经常 Timeout，暂无法解决；
3. CSRedis 于 2016 年开始支持 .NETCore 一直迭代至今，实现了低门槛、高性能，和分区高级玩法的 .NETCore redis-cli SDK；

在 v3.0 版本更新中，CSRedis 中的所有方法名称进行了调整，使其和 redis-cli 保持一致，如果你熟悉 redis-cli 的命令，CSRedis 可以直接上手，学习成本就低很多。

## 安装CSRedis &#x1F638;

直接使用 Visual Studio 中的 Nuget 包管理器搜索安装即可，使用连接字符串创建 redis 实例，并执行`RedisHelper.Initialization()`进行初始化。
```csharp
var csredis = new CSRedisClient("127.0.0.1:6379,password=YourPassword");
RedisHelper.Initialization(csredis);
```
如果你没有给redis设置密码，那么直接写上ip就行，否则的话要把password写进连接字符串中。
```csharp
var csredis = new CSRedisClient("127.0.0.1:6379");
RedisHelper.Initialization(csredis);
```
然后就可以进行redis操作了。

## 字符串(string)

关于字符串的`value`：
1. value 可以用来存储任意格式的数据，如 json、jpg 甚至是视频文件；
2. value 的最大容量是512M；
3. value 可以存储3种类型的值：字节串（byte string）、整数（int）、浮点数（double）；  

其中，整数的取值范围和系统的长整数取值范围相同，在32位的操作系统上，整数就是32位的；在64位操作系统上，整数就是64位有符号整数。浮点数的取值范围和 IEEE 754 标准的双精度浮点数相同。

```csharp
// 添加字符串键-值对
csredis.Set("hello", "1");
csredis.Set("world", "2");
csredis.Set("hello", "3");

// 根据键获取对应的值
csredis.Get("hello");

// 移除元素
csredis.Del("world");
```
在对同一个键多次赋值时，该键的值是最后一次赋值时的值，实例中`hello`对应的值最终为`3`。

由于redis可以对字符串的类型进行“识别”，所以除了对字符串进行增、删、查、之外，我们还可以对整数类型进行自增、自减操作，对字节串的一部分进行读取或者写入。以下是字符串的基本用法

```csharp
/*    数值操作    */
csredis.Set("num-key", "24");

// value += 5
csredis.IncrBy("num-key",5); 
// output -> 29

// value -= 10
csredis.IncrBy("num-key", -10); 
// output -> 19

/*    字节串操作    */
csredis.Set("string-key", "hello ");

// 在指定key的value末尾追加字符串
csredis.Append("string-key", "world"); 
// output -> "hello world"

// 获取从指定范围所有字符构成的子串（start:3,end:7）
csredis.GetRange("string-key",3,7)  
// output ->  "lo wo"
    
// 用新字符串从指定位置覆写原value（index:4）
csredis.SetRange("string-key", 4, "aa"); 
// output -> "hellaaword"
```

有一些非正常情况需要注意：对字节串进行自增、自减操作时，redis会报错；使用`Append`、`SetRange`方法对value进行写入时，字节串的长度可能不够用，这时redis会使用空字符(null)将value扩充到指定长度，然后再进行写入操作。

## 列表(list)

列表可以有序的存储多个字符串（字符串可以重复）等操作， 列表是通过链表来实现的，所以它添加新元素的速度非常快。

```csharp
// 从右端推入元素
csredis.RPush("my-list", "item1", "item2", "item3", "item4"); 
// 从右端弹出元素
csredis.RPop("my-list");
// 从左端推入元素
csredis.LPush("my-list","LeftPushItem");
// 从左端弹出元素
csredis.LPop("my-list");

// 遍历链表元素（start:0,end:-1即可返回所有元素）
foreach (var item in csredis.LRange("my-list", 0, -1))
{
    Console.WriteLine(item);
}
// 按索引值获取元素（当索引值大于链表长度，返回空值，不会报错）
Console.WriteLine($"{csredis.LIndex("my-list", 1)}"); 

// 修剪指定范围内的元素（start:4,end:10）
csredis.LTrim("my-list", 4, 10);
```
除了对列表中的元素进行以上简单的处理之外，还可以将一个列表中的元素复制到另一个列表中。在语义上，列表的左端默认为“头部”，列表的右端为“尾部”。

```csharp
// 将my-list最后一个元素弹出并压入another-list的头部
csredis.RPopLPush("my-list", "another-list");
```

## 集合(set)

集合以无序的方式存储**各不相同**的元素，也就是说在集合中的每个元素的`Key`都不重复。在redis中可以快速地对集合执行添加、移除等操作。

```csharp
// 实际上只插入了两个元素("item1","item2")
csredis.SAdd("my-set", "item1", "item1", "item2"); 

// 集合的遍历
foreach (var member in csredis.SMembers("my-set"))
{
    Console.WriteLine($"集合成员：{member.ToString()}");
}

// 判断元素是否存在
string member = "item1";
Console.WriteLine($"{member}是否存在:{csredis.SIsMember("my-set", member)}"); 
// output -> True

// 移除元素
csredis.SRem("my-set", member);
Console.WriteLine($"{member}是否存在:{csredis.SIsMember("my-set", member)}"); 
// output ->  False

// 随机移除一个元素
csredis.SPop("my-set");
```

以上是对一个集合中的元素进行操作，除此之外还可以对两个集合进行交、并、差操作

```csharp
csredis.SAdd("set-a", "item1", "item2", "item3","item4","item5");
csredis.SAdd("set-b", "item2", "item5", "item6", "item7");

// 差集
csredis.SDiff("set-a", "set-b"); 
// output -> "item1", "item3","item4"

// 交集
csredis.SInter("set-a", "set-b"); 
// output -> "item2","item5"

// 并集
csredis.SUnion("set-a", "set-b");
// output -> "item1","item2","item3","item4","item5","item6","item7"
```

另外还可以用`SDiffStore`,`SInterStore`,`SUnionStore`将操作后的结果存储在新的集合中。

## 散列(hashmap)

在redis中我们可以使用散列将多个键-值对存储在一个redis键上，从而达到将一系列相关数据存放在一起的目的。例如添加一个redis键`Article:1001`,然后在这个键中存放ID为1001的文章的标题、作者、链接、点赞数等信息。我们可以把这样数据集看作是关系数据库中的行。

```csharp
// 向散列添加元素
csredis.HSet("ArticleID:10001", "Title", "在.NET Core中使用CSRedis");
csredis.HSet("ArticleID:10001", "Author", "xscape");
csredis.HSet("ArticleID:10001", "PublishTime", "2019-01-01");
csredis.HSet("ArticleID:10001", "Link","https://www.cnblogs.com/xscape/p/10208638.html");

// 根据Key获取散列中的元素
csredis.HGet("ArticleID:10001", "Title");

// 获取散列中的所有元素
foreach (var item in csredis.HGetAll("ArticleID:10001"))
{
    Console.WriteLine(item.Value);
}
```

`HGet`和`HSet`方法执行一次只能处理一个键值对，而`HMGet`和`HMSet`是他们的多参数版本，一次可以处理多个键值对。

```csharp
var keys = new string[] { "Title","Author","publishTime"};
csredis.HMGet("ArticleID:10001", keys);
```

虽然使用`HGetAll`可以取出所有的value，但是**有时候散列包含的值可能非常大，容易造成服务器的堵塞**，为了避免这种情况，我们可以使用`HKeys`取到散列的所有键(*`HVals可以取出所有值`*)，然后再使用`HGet`方法一个一个地取出键对应的值。

```csharp
foreach (var item in csredis.HKeys("ArticleID:10001"))
{
	Console.WriteLine($"{item} - {csredis.HGet("ArticleID:10001", item)}");
}
```

和处理字符串一样，我们也可以对散列中的值进行自增、自减操作，原理同字符串是一样的。

```csharp
csredis.HSet("ArticleID:10001", "votes", "257");
csredis.HIncrBy("ArticleID:10001", "votes", 40);
// output -> 297
```

## 有序集合

有序集合可以看作是可排序的散列，不过有序集合的val成为score分值，集合内的元素就是基于score进行排序的，score以双精度浮点数的格式存储。

```csharp
// 向有序集合添加元素
csredis.ZAdd("Quiz", (79, "Math"));
csredis.ZAdd("Quiz", (98, "English"));
csredis.ZAdd("Quiz", (87, "Algorithm"));
csredis.ZAdd("Quiz", (84, "Database"));
csredis.ZAdd("Quiz", (59, "Operation System"));

//返回集合中的元素数量
csredis.ZCard("Quiz");

// 获取集合中指定范围(90~100)的元素集合
csredis.ZRangeByScore("Quiz",90,100);

// 获取集合所有元素并升序排序
csredis.ZRangeWithScores("Quiz", 0, -1);

// 移除集合中的元素
csredis.ZRem("Quiz", "Math");
```

## 管道(pipeline)
redis的事务可以通过pipeline实现的，使用pipeline时，客户端会自动调用`MULTI`和`EXEX`命令，**将多条命令打包并一次性地发送给redis，然后redis再将命令的执行结果全部打包并一次性返回给客户端**，这样有效的减少了redis与客户端的通信次数，提升执行多次命令时的性能。

```csharp
var pipe = csredis.StartPipe();
for (int i = 0; i < COUNT; i++)
{
    pipe.IncrBy("key-one"); // 将key-one中的值自增COUNT次，产生了COUNT条IncrBy命令
}
pipe.EndPipe(); // 在管道结束的位置，将COUNT条命令一次性发送给redis
Console.WriteLine($"{csredis.Get("key-one")}");
Console.ReadKey();
```
需要特别说明的是，redis中的事务不同于数据库的事务，如果执行命令期间发生错误，redis并不会回滚。

## Key的过期

redis还允许我们为key设置有效期，当key过期之后，key就不存在了。

```csharp
redis.Set("MyKey", "hello,world");
Console.WriteLine(redis.Get("MyKey")); 
// output -> "hello,world"

redis.Expire("MyKey", 5); // key在5秒后过期，也可以使用ExpireAt方法让它在指定时间自动过期

Thread.Sleep(6000); // 暂停6秒
Console.WriteLine(redis.Get("MyKey"));
// output -> ""
```

## 引用

- [Redis命令参考](http://doc.redisfans.com/index.html)
- [Redis实战](https://item.jd.com/11791607.html)
- [An introduction to Redis data types and abstractions](https://redis.io/topics/data-types-intro)
- [.NET Core简单且高级的库](http://www.cnblogs.com/kellynic/p/9803314.html)
- [Github:CSRedis](https://github.com/ctstone/csredis)