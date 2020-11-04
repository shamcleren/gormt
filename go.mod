module github.com/shamcleren/gormt

go 1.13

require (
	github.com/jinzhu/gorm v1.9.12
	github.com/jroimartin/gocui v0.4.0
	github.com/mattn/go-sqlite3 v2.0.1+incompatible
	github.com/nicksnyder/go-i18n/v2 v2.0.3
	github.com/spf13/cobra v1.0.0
	github.com/xxjwxc/gormt v0.0.0-20201030104547-9a6d72b83141
	github.com/xxjwxc/public v0.0.0-20200928160257-3db1045537d1
	golang.org/x/text v0.3.2
	gopkg.in/go-playground/validator.v9 v9.30.2
	gopkg.in/yaml.v3 v3.0.0-20191120175047-4206685974f2
	gorm.io/driver/mysql v1.0.1
	gorm.io/gorm v1.20.2
)

// replace github.com/xxjwxc/public => ../public
