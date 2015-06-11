因某些和谐原因，需要做一下天朝内工作。

------

#替换ruby gem 镜像：

		$ gem sources --remove https://rubygems.org/ 
		//等有反应之后再敲入以下命令 
		$ gem sources -a http://ruby.taobao.org/
		
------

#将CocoaPods替换成国内镜像

每次执行pod install的时候，总会因为各种各样你懂得的原因要等半天。如果替换成国内镜像，能极大减少pod命令操作的时间。

##[step 1]备份原有的master仓库

进入**~/.cocoapods/repos**目录，复制原有的**master**文件夹，重命名为**master_backup**。

##[step 2]加入国内镜像

执行

	pod repo remove master
	pod repo add master http://git.oschina.net/akuandev/Specs.git
	pod repo update
	
完成这两步后，我们的pod仓库已经更新为国内镜像了。

------
