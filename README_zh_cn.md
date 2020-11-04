[![Build Status](https://travis-ci.org/xxjwxc/gormt.svg?branch=master)](https://travis-ci.org/xxjwxc/gormt)
[![Go Report Card](https://goreportcard.com/badge/github.com/xxjwxc/gormt)](https://goreportcard.com/report/github.com/xxjwxc/gormt)
[![GoDoc](https://godoc.org/github.com/xxjwxc/gormt?status.svg)](https://godoc.org/github.com/xxjwxc/gormt)
[![Mentioned in Awesome Go](https://awesome.re/mentioned-badge.svg)](https://github.com/avelino/awesome-go) 

# [gorm-tools](https://github.com/xxjwxc/gormt)

--------

#### mysql数据库转 struct 工具,可以将mysql数据库自动生成golang sturct结构，带大驼峰命名规则。带json标签

[English](README.md)

## 交互界面模式

![show](/image/gormt/ui_cn.gif)

```
./gormt -g=true
```

## 命令行模式

![show](/image/gormt/out.gif)
```
./gormt -g=false
```
--------

## 安装

```
go get -u -v github.com/shamcleren/gormt @master
```

或者: [下载地址](https://github.com/xxjwxc/gormt/releases)

## 1. 通过当前目录 config.yml 文件配置默认配置项
```
base:
    is_dev : false
out_dir : ./model  # 输出目录
url_tag : json # web url tag(json,db(https://github.com/google/go-querystring))
language :  # 语言(English,中 文)
db_tag : gorm # 数据库标签(gorm,db)
singular_table : false  # 单表模式:true:禁用表名复数,false:采用表明复数 参考:gorm.SingularTable
simple : false # 简单输出(默认gorm标签不输出)
is_out_sql : false # 是否输出 sql 原信息
is_out_func : true # 是否输出 快捷函数
is_url_tag : true # 是否打web标记
is_foreign_key : true # 是否导出外键关联
is_gui : false # 是否ui模式显示
is_table_name : false # 是否直接生成表名函数
is_null_to_point : false # 数据库默认 'DEFAULT NULL' 时设置结构为指针类型
mysql_info:
    host : 127.0.0.1
    port : 3306
    username : root
    password : qwer
    database : oauth_db
```

## 2. 可以使用命令行工具更新配置项

```
./gormt -H=127.0.0.1 -d=oauth_db -p=qwer -u=root --port=3306
```

## 3. 查看帮助

```
./gormt --help
or
./gormt -h

-------------------------------------------------------
base on gorm tools for mysql database to golang struct

Usage:
  main [flags]

Flags:
  -d, --database string   数据库名
  -f, --foreign           是否导出外键关联
  -F, --fun               是否导出函数
  -g, --gui               是否ui显示模式
  -h, --help              help for main
  -H, --host string       数据库地址.(注意-H为大写)
  -o, --outdir string     输出目录
  -p, --password string   密码.
      --port int          端口号 (default 3306)
  -s, --singular          是否禁用表名复数
  -l, --url string        url标签(json,url)
  -u, --user string       用户名.
  
```

## 4. 支持gorm 相关属性 
   
- 数据库表,列字段注释支持
- singular_table 表名复数(大驼峰)
- json tag json标签输出
- gorm.Model 基本模型   [支持gorm.Model模式导出>>>](https://github.com/xxjwxc/gormt/tree/master/doc/export_cn.md)
- PRIMARY_KEY	将列指定为主键
- UNIQUE	将列指定为唯一
- NOT NULL	将列指定为非 NULL
- INDEX	创建具有或不带名称的索引, 如果多个索引同名则创建复合索引
- UNIQUE_INDEX	和 INDEX 类似，只不过创建的是唯一索引
- 支持外键相关属性 [简单带外键模式导出>>>](https://github.com/xxjwxc/gormt/tree/master/doc/export_cn.md)
- 支持函数导出(包括:外键，关联体，索引关...)[简单函数导出示例>>>](https://github.com/xxjwxc/gormt/blob/master/data/view/genfunc/genfunc_test.go)
- 支持默认值default 

### 您可以在这里丰富数据映射类型 [def](data/view/cnf/def.go) 。

## 5. 示例展示
sql:
```
CREATE TABLE `user_account_tbl` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `password` varchar(64) CHARACTER SET utf8 COLLATE utf8_general_ci NOT NULL,
  `account_type` int(11) NOT NULL DEFAULT '0' COMMENT '帐号类型:0手机号，1邮件',
  `app_key` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'authbucket_oauth2_client表的id',
  `user_info_tbl_id` int(11) NOT NULL,
  `reg_time` datetime DEFAULT NULL,
  `reg_ip` varchar(15) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `bundle_id` varchar(255) CHARACTER SET utf8 COLLATE utf8_general_ci DEFAULT NULL,
  `describ` varchar(255) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `account` (`account`) USING BTREE,
  KEY `user_info_id` (`user_info_tbl_id`) USING BTREE,
  CONSTRAINT `user_account_tbl_ibfk_1` FOREIGN KEY (`user_info_tbl_id`) REFERENCES `user_info_tbl` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=38 DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci COMMENT='用户账号'
```

###### --->导出结果

```
// UserAccountTbl 用户账号
type UserAccountTbl struct {
	ID            int    `gorm:"primary_key"`
	Account       string `gorm:"unique"`
	Password      string
	AccountType   int         // 帐号类型:0手机号，1邮件
	AppKey        string      // authbucket_oauth2_client表的id
	UserInfoTblID int         `gorm:"index"`
	UserInfoTbl   UserInfoTbl `gorm:"association_foreignkey:user_info_tbl_id;foreignkey:id"` // 用户信息
	RegTime       time.Time
	RegIP         string
	BundleID      string
	Describ       string
}
```

### [更多>>>](https://github.com/xxjwxc/gormt/tree/master/doc/export_cn.md)

## 6. 支持函数导出(导出函数只是 gorm 的辅助类函数，完全兼调用 gorm)

```
// FetchByPrimaryKey primay or index 获取唯一内容
func (obj *_UserAccountTblMgr) FetchByPrimaryKey(ID int) (result UserAccountTbl, err error) {
	err = obj.DB.Table(obj.GetTableName()).Where("id = ?", ID).Find(&result).Error
	if err == nil && obj.isRelated {
		{
			var info UserInfoTbl // 用户信息
			err = obj.DB.Table("user_info_tbl").Where("id = ?", result.UserInfoTblID).Find(&info).Error
			if err != nil {
				return
			}
			result.UserInfoTbl = info
		}
	}

	return
}

```

### [更多>>>](https://github.com/xxjwxc/gormt/tree/master/doc/func_cn.md)

### [函数调用示例>>>](https://github.com/xxjwxc/gormt/blob/master/data/view/genfunc/genfunc_test.go)

## 7. 构建
```
make windows
make linux
make mac
```
or

```
go generate
```


### 说明：windows 不支持中文默认方式。ASCALL 模式
切换编码方式
```
CHCP 65001 
```

### 表注释 default

- 给列添加注释以`[@gormt default:'test']`开头即可


## 8. 下一步计划

- 更新，删除功能函数添加
- 优化

## 9. 提供一个windows 可视化工具

![图片描述](/image/gormt/1.png)

![图片描述](/image/gormt/2.jpg)

![图片描述](/image/gormt/3.jpg)

![图片描述](/image/gormt/4.jpg)

[下载地址](https://github.com/xxjwxc/gormt/releases/download/v0.3.8/v1.0.zip)


- ###### [传送门](https://xxjwxc.github.io/post/gormtools/)

## 点赞时间线

[![Stargazers over time](https://starchart.cc/xxjwxc/gormt.svg)](https://starchart.cc/xxjwxc/gormt)
