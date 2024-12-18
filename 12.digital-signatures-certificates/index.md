# 数字签名, 数字证书以及加密传输


## 预备概念简单介绍

- 对称加密：加密和解密使用同一个密钥
- 非对称加密：又称公钥加密，加密和解密使用不同的密钥，分别称为公钥和私钥，公钥公开，私钥保密，使用公钥加密，使用私钥解密
- 摘要算法：本质上是一类安全领域上使用的hash算法，摘要算法会根据输入数据生成一个固定长度的摘要数据，摘要算法是不可逆的，即无法通过摘要反推出原始数据，摘要可以用来唯一标识一个输入数据，即不同的输入数据会生成不同的摘要，同一个输入数据生成的摘要总是相同的
- 数字签名：使用摘要算法对数据做摘要，并用私钥对摘要进行加密，生成一个固定长度的数据，用于验证数据的完整性
- 数字证书：包含公钥和数字签名，用于验证公钥的正确性
- 公钥基础设施（PKI）：公钥基础设施是一个以公钥加密技术为基础，为网络通信提供安全服务所必须的硬件、软件、人员、策略、规程和文档等构成的集合

## 数字签名

数字签名的作用是保证消息的正确性和完整性，主要通过对消息做摘要来保证。

同时，为了保证消息和摘要的安全性，还要使用非对称加密技术，用发送者的私钥对消息和摘要进行加密，接收者用发送者的公钥对消息和摘要解密后再进行签名验证。

具体的交互流程是

1. 发送人对消息做摘要和加密，生成数字签名和加密信息，并将签名和信息一起发送给接收人
2. 接收人收到消息后，使用发送人的公钥解密摘要和消息
3. 接收人校验数字签名，校验通过后，即可证明消息的完整性

## 数字证书

### 相关概念介绍

- 证书颁发机构（CA）：CA是PKI的核心，负责证书的签发和吊销，CA的公钥和私钥是成对出现的，CA的公钥和私钥用于验证证书的正确性
- 根证书：CA的根证书是CA的公钥和私钥的集合，用于验证证书的正确性
- 中间证书：CA的中间证书是CA的公钥和私钥的集合，用于验证证书的正确性
- 证书链：证书链是证书的集合，用于验证证书的正确性

### 数字证书要解决什么问题

在使用数字签名的过程中存在一个问题，即接收人无法判断发送人的公钥是否可信，换言之，发送人提供的公钥有可能被篡改或伪造。数字证书就是为了解决公钥的可信性问题而被发明出来的。

### 数字证书的签发和验证过程

具体的做法是，由一个权威的证书颁发机构（CA）使用它自己的公钥对发送人的公钥做一个数字签名，并将这个数字签名作为证书颁发给发送人，发送人给接收人发送消息时，将证书一并附上，由接收人去验证。CA会为其自己的公钥颁发一个根证书，提前提供给用户，用户从根证书中获取到CA的公钥，对发送人的证书进行验证。

简单来说，用户先从根证书中拿到CA的公钥，再利用CA的公钥验证发送人的公钥是否正确，从而验证发送人的身份。

在CS架构的通信中，一般服务端要去向CA申请服务器证书，并在通信时将服务器证书发送给客户端，客户端提前拿到CA的根证书，并利用根证书对服务器证书进行验证，从而验证服务端的身份。

证书的签发和验证过程具体如下：

1. CA生成一个公私钥对，用私钥对公钥做签名，然后生成根证书（.crt文件，其中包含公钥和签名）
2. 服务端生成自己的公私钥对，并用私钥对公钥生成一个签发请求（.csr文件，其中包含公钥和签名），向CA请求签发证书
3. CA拿到签发请求后，用自己的公钥对服务端的公钥做签名，生成服务端证书（.crt文件），并将证书颁布给服务端
4. 客户端提前安装好CA的根证书
5. 服务端将服务端证书发送给客户端，客户端利用利用CA的根证书对服务端的证书做验证

## X.509证书

x.509证书是一种由ITU（International TelecommumcationUnion，国际电信联盟）制定的数字证书通用规范标准，自1998年以来，已经发展了三个版本，分别是x.509 v1，x.509 v2和x.509 v3，目前人们说的x.509一般是指x.509 v3证书。

x.509证书中最重要的两个字段，证书持有者的公钥（Subject Public Key Info），以及签名（Signature）

x.509的编码格式是ASN.1

参考[https://learn.microsoft.com/zh-cn/azure/iot-hub/reference-x509-certificates](https://learn.microsoft.com/zh-cn/azure/iot-hub/reference-x509-certificates)


## 证书和密钥文件格式

证书和密钥一般有两种格式，der格式和pem格式

der格式是原始的二进制格式，pem格式是base64编码格式，并且一般带有类似`-----BEGIN CERTIFICATE-----`和`-----END CERTIFICATE-----`的开头和结尾，表明文件的类型，pem格式是最常见的证书或密钥格式

实际的文件扩展名有多种，常见的有`.pem`、`.der`、`.key`、`.csr`、`.crt`等，文件内部真正的格式只有der和pem两种

除了der和pem以外，证书还有一些其他存储格式，例如pks7、pks8、pks12等

证书和公私钥的编码格式一般是ASN.1，参考[https://learn.microsoft.com/zh-cn/windows/win32/seccertenroll/about-introduction-to-asn-1-syntax-and-encoding](https://learn.microsoft.com/zh-cn/windows/win32/seccertenroll/about-introduction-to-asn-1-syntax-and-encoding)

## 如何用openssl签发和验证x509证书

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

## 签名算法

签名主要使用摘要算法和非对称加密算法来实现

非对称加密主要用途是做密钥协商（密钥交换）、生成和验证数字签名和证书

- RSA，最早的公钥加密，是目前兼容性最好的，应用最广泛的公钥加密
- DSA，数字签名算法，因为安全问题，已不再使用了
- ECDSA，DSA的椭圆曲线实现
- EdDSA，另外一种基于曲线的非对称加密
- Ed25519：是目前最安全、加解密速度最快的基于椭圆曲线的非对称加密算法。是curve 25519算法中的一种，curve 25519包含两种算法，x25519和ed25519，x25519用来做密钥协商，ed25519用来做数字签名和证书

## 关于椭圆曲线加密

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

## https协议

### https和http的区别

1. https在http的基础上增加了SSL/TLS协议，SSL/TLS依靠证书验证服务器身份，并对浏览器和服务器之间的通信进行加密
2. https使用443端口，http使用80端口

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

