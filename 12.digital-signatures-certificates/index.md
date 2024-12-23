# 数字签名, 数字证书以及加密通信


## 一、预备概念

- 对称加密：加密和解密使用同一个密钥
- 非对称加密：又称公钥加密，加密和解密使用不同的密钥，分别称为公钥和私钥，公钥公开，私钥保密，使用公钥加密，使用私钥解密
- 摘要算法：本质上是一类安全领域上使用的hash算法，摘要算法会根据输入数据生成一个固定长度的摘要数据，摘要算法是不可逆的，即无法通过摘要反推出原始数据，摘要可以用来唯一标识一个输入数据，即不同的输入数据会生成不同的摘要，同一个输入数据生成的摘要总是相同的
- 数字签名：使用摘要算法对数据做摘要，并用私钥对摘要进行加密，生成一个固定长度的数据，用于验证数据的完整性
- 数字证书：包含公钥和数字签名，用于验证公钥的正确性
- 公钥基础设施（PKI）：公钥基础设施是一个以公钥加密技术为基础，为网络通信提供安全服务所必须的硬件、软件、人员、策略、规程和文档等构成的集合

## 二、数字签名

### 数字签名要解决什么问题

1. 接收方无法验证消息的正确性和完整性，换句话说，接收方不知道消息是否在传输过程中损坏，也不知道消息是否被篡改过。
2. 接收方无法验证消息发送者的身份，换句话说，接收方不知道消息是否真的是由发送者发送的，还是其他人伪造的。

### 数字签名如何解决上述问题

数字签名利用摘要算法和公钥加密解决上述两个问题

发送方通过摘要算法为消息生成一个唯一的标识，接收方接收到消息后重新对消息做摘要，如果和发送方生成的摘要一致，则说明消息在传输过程中没有被损坏或篡改。

同时，为了验证消息发送者的身份，还要使用公钥加密技术，用发送者的私钥对摘要进行加密，接收者用发送者的公钥对摘要解密后再进行签名验证，如果使用发送者的公钥无法解密出正确的摘要，说明这个公钥不是消息发送者的，即消息发送者的身份是不可信的。

### 数字签名的交互过程

数字签名分为两个过程，签名和验签，由发送方对消息签名，由接收方验证消息签名

具体的交互流程是

1. 发送人对消息做摘要，并对摘要加密后生成数字签名，然后将签名和消息一起发送给接收人
2. 接收人收到消息后，使用发送人的公钥解密摘要
3. 接收人通过重新计算消息摘要的方式校验数字签名，如果摘要和加密后的摘要一致，则校验通过，即可证明消息的完整性和消息发送者的身份可信

## 三、数字证书

### 数字证书要解决什么问题

在使用数字签名的过程中存在一个问题，即接收人无法判断发送人的公钥是否可信，换言之，发送人提供的公钥有可能被篡改或伪造。数字证书就是为了解决公钥的可信性问题而被发明出来的。

### 数字证书如何解决这个问题

本质上来讲，数字证书是一种特殊的数字签名，和一般的数字签名的区别在于，数字证书是对消息发送人的公钥签名，而一般的数字签名是对一般性的消息做签名。

对公钥做签名同样面临签名者的公钥可信性问题，为此，引入了一个权威的第三方机构，这个第三方机构称为证书颁发机构（CA），由CA去给消息发送人颁发证书，CA的可信性来源于公共信用，即大家都同意CA是可信的，不需要再对CA做验证。

CA使用自己的私钥对消息发送人的公钥做签名，并将这个数字签名作为证书颁发给发送人，发送人给接收人发送消息时，将证书一并附上，由接收人去验证。CA会为自己的公钥颁发一个根证书，提前提供给用户，用户从根证书中获取到CA的公钥，对发送人的证书进行验证，并取得发送人的公钥，从而解决了公钥的可信性问题。

![证书颁发和验证过程](/posts/12.digital-signatures-certificates/cert-interactions.png)

### 数字证书的签发和验证过程

在CS架构的通信中，一般服务端要去向CA申请服务器证书，并在通信时将服务器证书发送给客户端，客户端提前拿到CA的根证书存储在本地，并利用根证书对服务器证书进行验证，从而验证服务端的身份。

证书的签发和验证过程具体如下：

1. CA生成一个公私钥对，用私钥对公钥做签名，然后生成根证书（.crt文件，其中包含公钥和签名）
2. 服务端生成自己的公私钥对，并用私钥对公钥生成一个签发请求（.csr文件，其中包含公钥和签名），向CA请求签发证书
3. CA拿到签发请求后，用自己的公钥对服务端的公钥做签名，生成服务端证书（.crt文件），并将证书颁布给服务端
4. 客户端提前安装好CA的根证书
5. 服务端将服务端证书发送给客户端，客户端利用利用CA的根证书对服务端的证书做验证

### 自签证书

- 自签证书 是指自己给自己签发的证书
- 根证书是一种自签证书
- 自签证书一般只用来做测试

### X.509证书

x.509证书是一种由ITU（International TelecommumcationUnion，国际电信联盟）制定的数字证书通用规范标准，自1998年以来，已经发展了三个版本，分别是x.509 v1，x.509 v2和x.509 v3，目前人们说的x.509一般是指x.509 v3证书。

x.509证书中最重要的两个字段，证书持有者的公钥（Subject Public Key Info），以及签名（Signature）

x.509的编码格式是ASN.1

参考[https://learn.microsoft.com/zh-cn/azure/iot-hub/reference-x509-certificates](https://learn.microsoft.com/zh-cn/azure/iot-hub/reference-x509-certificates)


### 证书和密钥文件格式

证书和密钥一般有两种格式，der格式和pem格式

der格式是原始的二进制格式，pem格式是base64编码格式，并且一般带有类似`-----BEGIN CERTIFICATE-----`和`-----END CERTIFICATE-----`的开头和结尾，表明文件的类型，pem格式是最常见的证书或密钥格式

实际的文件扩展名有多种，常见的有`.pem`、`.der`、`.key`、`.csr`、`.crt`等，文件内部真正的格式只有der和pem两种

除了der和pem以外，证书还有一些其他存储格式，例如pks7、pks8、pks12等

证书和公私钥的编码格式一般是ASN.1，参考[https://learn.microsoft.com/zh-cn/windows/win32/seccertenroll/about-introduction-to-asn-1-syntax-and-encoding](https://learn.microsoft.com/zh-cn/windows/win32/seccertenroll/about-introduction-to-asn-1-syntax-and-encoding)

### 如何用openssl签发和验证x509证书

```bash
#生成根私钥（使用ed25519算法）
 ./openssl genpkey -algorithm ed25519 -out tmp/ed25519_ca_pri -outform pem

#生成根公钥
./openssl pkey -in .\tmp\ed25519_ca_pri -pubout -out tmp/ed25519_ca_pub

#生成根证书（字段都要填，一般证书以.crt作为扩展名）
./openssl req -new -x509 -days 3650 -key .\tmp\ed25519_ca_pri -keyform pem -out ./tmp/ca_crt

You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:

#打印证书内容
./openssl x509 -in .\tmp\ca_crt -noout -text

#验证根证书（自己验证自己）
./openssl verify -CAfile .\tmp\ca_crt .\tmp\ca_crt

.\tmp\ca_crt: OK

#从证书中提取根公钥
openssl x509 -in tmp1/ca_crt -pubkey -noout


#生成用户私钥
./openssl genpkey -algorithm ed25519 -out tmp/ed25519_usr_pri -outform pem

#生成用户公钥
./openssl pkey -in .\tmp\ed25519_usr_pri -pubout -out tmp/ed25519_usr_pub

#生成用户证书签发请求（不带-x509参数就是生成签发请求，带上x509和时间就是生成证书，字段都要填，一般签发请求以.csr作为扩展名）
 ./openssl req -new -key .\tmp\ed25519_usr_pri -out ./tmp/usr_req

You are about to be asked to enter information that will be incorporated
into your certificate request.
What you are about to enter is what is called a Distinguished Name or a DN.
There are quite a few fields but you can leave some blank
For some fields there will be a default value,
If you enter '.', the field will be left blank.
-----
Country Name (2 letter code) [AU]:
State or Province Name (full name) [Some-State]:
Locality Name (eg, city) []:
Organization Name (eg, company) [Internet Widgits Pty Ltd]:
Organizational Unit Name (eg, section) []:
Common Name (e.g. server FQDN or YOUR name) []:
Email Address []:

Please enter the following 'extra' attributes
to be sent with your certificate request
A challenge password []:
An optional company name []:

#打印用户签发请求内容
./openssl req -in tmp/usr_req -noout -text

#为用户签发证书

./openssl x509 -req -days 3650 -in .\tmp\usr_req -CA .\tmp\ca_crt -CAkey .\tmp\ed25519_ca_pri -CAcreateserial -out tmp/usr_crt

Certificate request self-signature ok
subject=C = AU, ST = Some-State, O = Internet Widgits Pty Ltd

#验证用户证书
./openssl verify -CAfile .\tmp\ca_crt .\tmp\usr_crt

#从证书中提取用户公钥
openssl x509 -in tmp1/usr_crt -pubkey -noout

#使用用户私钥进行签名
./openssl pkeyutl -sign -inkey .\tmp1\ed25519_usr_pri -out tmp1/usr_sig -rawin -in .\tmp1\data.txt

#使用用户公钥进行验签
./openssl pkeyutl -verify -pubin -inkey .\tmp1\ed25519_usr_pub -rawin -in .\tmp1\data.txt -sigfile .\tmp1\usr_sig

Signature Verified Successfully

#证书格式转换，从der格式转为pem格式
openssl x509 -inform der -in certificate.der -out certificate.pem
```

## 四、加密通信

加密通信 = 密钥协商 + 对称加密

### 对称加密和公钥加密的对比

| 特性 | 对称加密 | 公钥加密 |
|------|----------|----------|
| 加密速度 | 快 | 慢 |
| 密钥管理 | 复杂，需要安全分发密钥 | 简单，公钥可以公开分发 |
| 主要用途 | 数据加密传输 | 密钥交换、数字签名、数字证书 |
| 典型算法 | AES、DES | RSA、ECC |

### 常见公钥加密算法

非对称加密主要用途是做密钥协商（密钥交换）、生成和验证数字签名和证书

| 算法 | 名字 | 类型 | 说明 |
|------|------|------|------|
| RSA | Ron Rivest, Adi Shamir, Leonard Adleman | 公钥加密 | 最早的公钥加密，是目前应用最广泛的公钥加密，目前认为2048位的RSA密钥是安全的（1024位的密钥已不安全） |
| DSA | Digital Signature Algorithm | 专门用于数字签名，由美国国家标准与技术研究院 (NIST) 于 1991 年提出，并于 1993 年被联邦信息处理标准 (FIPS) 采用 | 存在已知的安全性和政治问题，参考[https://www.fisec.cn/1256.html](https://www.fisec.cn/1256.html) |
| ECC | 椭圆曲线加密算法 | 一类算法 | 用于非对称加密，密钥交换和数字签名。密钥比RSA短，性能和安全性强于RSA |
| ECDSA | 椭圆曲线数字签名算法 | 数字签名 | 用于数字签名，是DSA的ECC实现。在区块链网络（比特币、以太坊）中被大量使用 |
| ECDH | 椭圆曲线密钥交换算法 | 密钥交换 | DH（Diffie-Hellman）是一种密钥交换算法，DH密钥交换的ECC实现。由于密钥不是临时的，不安全，被openssl默认弃用 |
| ECDHE | 椭圆曲线密钥交换算法 | 密钥交换 | 比ECDH多个E，代表生成的密钥是临时的，即每次会话都会重新生成密钥。TLS/SSL主要的两种密钥交换算法之一（ECDHE和RSA） |
| EdDSA | 爱德华兹曲线数字签名算法 | 数字签名 | 是一种基于扭曲爱德华兹曲线和Schnorr签名的数字签名方案。它比DSA和ECDSA更安全 |
| Ed25519 | 基于25519曲线的EdDSA数字签名算法 | 数字签名 | 是一种基于SHA-512和ed25519的EdDSA数字签名算法（ed25519曲线是扭曲爱德华兹曲线的一个实例，由Daniel J. Bernstein提出）。被大量使用的起因是2013年斯诺登曝光的美国棱镜计划，此前25519曲线只在学术界被使用。无论是安全性还是性能，都优于RSA、ECDSA算法。使用少，是因为出现时间晚 |
| x25519 | 基于curve25519曲线的密钥交换算法 | 密钥交换 | Curve25519曲线是蒙哥马利椭圆曲线的一个实例，由Daniel J. Bernstein提出 |

### 关于椭圆曲线加密

椭圆曲线加密有两种有限域，Fp域（素数域），即有限域的范围为素数；F2m域，即特征为2的有限域，称之为二元域或者二进制扩展域，该域中，元素的个数为2m个。

素数域的五个参数(p,a,b,G,n,h)，p是有限域的范围，a和b确定曲线的形状，G是计算的基点，n是加法的次数，h是协因子

二进制扩展域的参数(m,f(x),a,b,G,n,h)，其中，m确定F2m，f(x)为不可约多项式，a和b用于确定椭圆曲线方程，G为基点，n为G的阶，h为余因子。

私钥=一个随机数，公钥=私钥乘以基点G

椭圆曲线有多种国际标准

1) X9.62，Public Key Cryptography For The Financial Services Industry: The Elliptic Curve Digital Signature Algorithm (ECDSA)；
2) SEC 1，Elliptic Curve Cryptography；
3) SEC 2，Recommended Elliptic Curve Domain Parameters；
4) NIST，(U.S.) National Institute of Standards and Technology，美国国家标准。

这些标准一般都描述了Fp域和F2m域、椭圆曲线参数、数据转换、密钥生成以及推荐了多种椭圆曲线。

### 加密算法的OID

OID，Object Identifier，对象标识符，用于标识一个对象，OID一般用来标识一个算法、一个确定参数的椭圆曲线之类的东西。

### SSL/TLS

- SSL，Secure Sockets Layer
- TLS，Transport Layer Security
- SSL/TLS是对因特网上的数据传输进行身份验证和加密的协议，SSL/TLS是对ssl和tls的统称，tls更先进，更安全的ssl，正在逐渐取代ssl
- SSL/TLS有多个版本，使用[How’s My SSL](https://www.howsmyssl.com/)工具查看你的浏览器使用的是哪个SSL/TLS版本
- SSL/TLS的握手过程
    1. 客户端和服务器互相告知各自支持的SSL/TLS版本，加密算法和压缩算法
    2. 客户端验证服务器证书，并获得服务器公钥
    3. 双方通过协商生成会话秘钥（会话秘钥是一个对称秘钥，对称加密比公钥加密快）
    4. 双方使用会话秘钥进行加密通信

### https协议

1. https在http的基础上增加了SSL/TLS协议，SSL/TLS依靠证书验证服务器身份，并对浏览器和服务器之间的通信进行加密
2. https使用443端口，http使用80端口



