## 目标

![image-20200310111412882](C:\Users\11344\AppData\Roaming\Typora\typora-user-images\image-20200310111412882.png)



## 准备

1. 有一个 AWS 账号（放心，本示例除了 KMS服务外不会额外损耗您的任何费用，你也可以选择不使用  KMS  服务）

   在 IAM 中新建一个用于运行此示例的用户, 并确保拥有如下权限：

   AmazonRDSFullAccess

   AmazonEC2FullAccess

   AmazonS3FullAccess

   CloudWatchFullAccess

   AmazonDynamoDBFullAccess

   

   下载记录该用户的 access_key_id 以及 secret_access_key

   

2. 下载安装 awscli 工具，并添加到系统 path 中，然后运行：

   `aws configure`

   根据提示，填入步骤 1 中记录的两个参数

   

3. 设置 mysql 密码

   - 使用 kms 

      在amazon kms 中新建一个密钥，然后使用该密钥加密数据库的密码。

      ```
      $ echo -n 'master-password' > plaintext-password
      $ aws kms encrypt --key-id ab123456-c012-4567-890a-deadbeef123 --plaintext fileb://plaintext-password --encryption-context foo=bar --output text --query CiphertextBlob
      AQECAHgaPa0J8WadplGCqqVAr4HNvDaFSQ+NaiwIBhmm6qDSFwAAAGIwYAYJKoZIhvcNAQcGoFMwUQIBADBMBgkqhkiG9w0BBwEwHgYJYIZIAWUDBAEuMBEEDI+LoLdvYv8l41OhAAIBEIAfx49FFJCLeYrkfMfAw6XlnxP23MmDBdqP8dPp28OoAQ==
      ```

      将上述的base64编码字符串赋值粘贴到 live/stage/data-store/mysql/main.tf 的 22 行

      

   - 不使用 KMS

      更改 live/stage/data-store/mysql/varables.tf  中的db_password为你需要的密码值（注意，这里是明文）



## 注意

因为 S3 等参数可能需要全局唯一的值，如果运行中保存，按照提示更改下就好



## 构建

分别进入 

live/global/s3 

live/stage/data-stores/mysql

live/stage/services/hello-world-app

执行：

`terraform init`

`terraform apply`

在最后 hello-world-app 构建完后会输出 alb_dns_name, 复制值到浏览器执行 http://${alb_dns_name} 就能看到结果



## 销毁

按照构建的反顺序，依次执行

`terraform destory`