> npm i deasync@0.1.22命令时，会运行 包里的 build.js 文件，检测当前环境，如果不满足将会编译 c++源码， build.js 里有很多 console.log('Binary is fine; exiting'); 类似的日志输出， 这个是输出到哪里了？ 我看 npm i 里没有相关 内容（想知道那个条件没有满足 造成需要编译源码），调整了 npm i --verbose 日志输出 也没找到 console.log的输出 。 home下.npm/_logs 也看了 没有

>npm i --verbose 增加了 安装日志
> 
>``` bash
> npm install deasync@0.1.22 --loglevel=verbose --foreground-scripts
> ```
