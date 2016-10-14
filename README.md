# WQGuideView
引导视图<br/>

<p align="center" >
  <img src="https://github.com/AppleDP/WQGuideView/blob/master/WQGuideView/Gif/GuideView1.gif" alt="Effectg" title="Effect">
</p>

# Principle
http://www.jianshu.com/p/261b79ee392c

# Usage<br/>
使用默认样式快速调用 WQGuideView
```objective-c
    WQGuideView *guideView = [[WQGuideView alloc] initWithFrame:self.view.bounds
                                                         guides:mutableGuides];
    [self.view addSubview:guideView];
    [guideView showGuide];
```


