# ffmpeg命令行例子


## ffprobe

查看音视频流信息，`ffprobe -show_streams "xxx.mp4"`

查看视频比特率，`ffprobe -v error -select_streams v:0 -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 "xxx.mp4"`

查看帧类型，`.\ffprobe.exe -v error -show_frames .\normal.mp4 | findstr pict_type > nmormal-type.json`

查看packet信息（pts和dts），`.\ffprobe.exe -i .\normal.mp4 -select_streams v -show_packets -print_format json > normal-out.json`

## ffmpeg查询参数支持

查看编码器支持的参数，`ffmpeg -h encoder=h264`

查看支持的编解码器， `ffmpeg -codecs`，`ffmpeg -encoders`，`ffmpeg -decoders`

查看支持的硬件加速方案，`ffmpeg -hwaccels`

## h264质量恒定参数

- libx264: `-crf`, -1~51，0为无损压缩，值越小质量越高，参考`./ffmpeg -h encoder=libx264`
- h264_nvenc: `-cq`，0~51，0表示自动，值越小质量越高，参考`./ffmpeg -h encoder=h264_nvenc`
- h264_qsv: `-global_quality`，1~51，值越小质量越高，参考[https://ffmpeg.org/ffmpeg-codecs.html](https://ffmpeg.org/ffmpeg-codecs.html)
- h264_amf: `-rc qvbr -qvbr_quality_level 50`，-1~51，值越大质量越高，参考`./ffmpeg -h encoder=h264_amf`
- h264_mf: `-rate_control quality -quality 80`，-1~100，值越大质量越高，参考`./ffmpeg -h encoder=h264_mf`

## ffmpeg 命令示例

### 叠加透明视频

`ffmpeg -hwaccel cuda -c:v h264  -i "D:\test\video\2024-08-27_14-12-25\hl_2024-08-27_14-21-29.mp4"  -c:v libvpx-vp9  -itsoffset 3000ms -i "D:\test\materials\effects\kill\effect9.webm"  -filter_complex "[0][1] overlay=alpha=1:eof_action=pass[o1];"  -map "[o1]"  -y  -c:v h264_nvenc -cq 23 -profile:v high -pix_fmt yuv420p  -r 30  "D:\test\tmpgamehleditor11\e0.mp4"`

### 两个视频之间拼接并增加转场特效

`ffmpeg -hwaccel cuda -c:v h264  -i "D:\test\tmpgamehleditor11\e1.mp4"  -hwaccel cuda -c:v h264  -i "D:\test\tmpgamehleditor11\e2.mp4" -filter_complex "xfade = transition =fade:duration =2000ms:offset =7533ms"  -c:v h264_nvenc -cq 23 -profile:v high -pix_fmt yuv420p  -r 30  -y "D:\test\tmpgamehleditor11\merge_0.mp4"`

### 三个视频拼接

`ffmpeg -i "D:\test\materials\begin_end\b egin.webm"  -hwaccel cuda -c:v h264  -i "D:\test\tmpgamehleditor11\merge_1.mp4" -i "D:\test\materials\begin_end\e nd.webm"  -filter_complex "[0:v][1:v][2:v]concat=n=3:v=1[out]" -map "[out]" -y  -c:v h264_nvenc -cq 23 -profile:v high -pix_fmt yuv420p  -r 30  "D:\test\tmpgamehleditor11\begin_end.mp4"`

### 叠加水印图片

`ffmpeg -hwaccel cuda -c:v h264  -i "D:\test\tmpgamehleditor11\begin_end.mp4" -i "D:\test\materials\Videos, footage and additional effects are all automatically recorded and edited..png"  -filter_complex "[0:v][1:v]overlay=(main_w-overlay_w)/2:main_h-overlay_h-10[out]" -map "[out]" -y  -c:v h264_nvenc -cq 23 -profile:v high -pix_fmt yuv420p  -r 30  "D:\test\tmpgamehleditor11\watermark.mp4"`

### 调整视频分辨率

`ffmpeg -hwaccel cuda -c:v h264  -i "D:\test\tmpgamehleditor11\watermark.mp4" -vf scale=1920:1080 -y  -c:v h264_nvenc -cq 23 -profile:v high -pix_fmt yuv420p  -r 30  "D:\test\tmpgamehleditor11\res.mp4"`

### 增加bgm

`ffmpeg -hwaccel cuda -c:v h264  -an -i "D:\test\tmpgamehleditor11\res.mp4"  -stream_loop -1 -i "D:\test\materials\bgm\m 1.aac"  -c:v copy -t 30133ms -y "D:\test\Final.mp4"`

## 叠加视频时指定前景视频播放持续时间

核心是这个表达式x='if(gte(t-1.733,1), NAN, 0)'，原理是超过时间以后，给叠加坐标设定一个视频画面外的值

`./ffmpeg.exe -hwaccel cuda -c:v h264  -i "D:\test\video\2024-08-27_14-12-25\hl_2024-08-27_14-21-29.mp4"  -c:v libvpx-vp9  -itsoffset 1733ms -i "D:\test\materials\effects\kill\e ffect9.webm" -filter_complex "[0][1]overlay=x='if(gte(t-1.733,1), NAN, 0)':y=0:alpha=1:eof_action=pass[o1];"  -map "[o1]"  -y  -c:v h264_nvenc -cq 23 -profile:v high -pix_fmt yuv420p  "D:\test\e0.mp4"`

## 画面定格

让第3秒的画面定格2s, loop=60代表重复60帧，由于输出视频设定了30fps的帧率（-r 30），所以定格时长是2s

`./ffmpeg.exe -hwaccel cuda -c:v h264  -i "D:\test\video\2024-08-27_14-12-25\hl_2024-08-27_14-21-29.mp4"  -filter_complex "[0:v]loop=loop=60:size=1:start=-1:time=3[o1];"  -map "[o1]"  -y  -c:v h264_nvenc -cq 23 -profile:v high -pix_fmt yuv420p -r 30 "D:\test\e0.mp4"`

## 视频画面缩放（zoom）

1. 在视频的第3到5秒，将画面逐渐放大到2倍，在第5到7秒保持这个倍率不变，视频其余时间保持原先的大小
2. 过程中会将画面以一个点为中心放大，并且会移动整个画面，目的是将这个点尽量移动到画面的中心位置
3. 为了更好地观看放大过程，我们先给放大中心点上叠加了一个星星作为辅助

`./ffmpeg.exe -hwaccel cuda -c:v h264 -i "D:\test\video\2024-08-27_14-12-25\hl_2024-08-27_14-21-29.mp4" -i "D:\test\icons8-star-48.png" -filter_complex "[0][1]overlay=480-24:540-24[o1];[o1]zoompan=zoom='if(between(it, 3, 7),min((it-3),2)/2*3+1,1)':s='hd1080':d=1:fps=30:x='480-(iw/zoom/2)':y='540-(ih/zoom/2)'[o];" -map "[o]" -y  -c:v h264_nvenc -cq 23 -profile:v high -pix_fmt yuv420p "D:\test\e0.mp4"`

// 以下详细说明zoompan这个滤镜  
// zoompan滤镜是对每个输入的帧生成一系列帧，实现对输入帧放大，并将原始画面中的指定点移动到屏幕中心位置，  
// zoompan的有两种放大，一种是视觉上的放大，看起来就好像在手机上两指放大一张图片一样，一种是调整视频分辨率，  
// 这两种放大不冲突，可以同时设置，分辨率调整以后，画面仍然有视觉上放大的效果  
// 如果我们想让视频的某一段画面的所有帧都放大，而不是通过一张静态的图片生成一段放大的画面，将d参数设置为1即可，d参数设置的是一个输入帧生成多少输出帧  
// 下面解释这条命令的各个参数  
// `zoompan=zoom='if(between(it, 3, 7),min((it-3),2)/2*3+1,1)':s='hd1080':d=1:fps=30:x='480-(iw/zoom/2)':y='540-(ih/zoom/2)'`
// 参数1：`zoom='if(between(it, 3, 7),min((it-3),2)/2*3+1,1)'`  
//		zoom参数是放大倍率，最低为1，这里我们应用了一个表达式，对视频的3-7秒应用放大效果，其余时间放大倍率为1，it是输入帧的时间戳，单位是s  
//		我们希望最终放大4倍，并且是逐渐放大，由于基础放大倍率是1，所以表达式采取了 递增倍率+1 的形式，即 `min((it-3),2)/2*3 + 1`  
//		递增倍率 = `min((it-3),2)/2*3`，`min((it-3),2)/2`是一个比例，值在0-1之间，比例`*3`就是就是递增倍率，当比例逐渐增加到1时，总倍率为`1*3+1`，也就是放大4倍  
//		比例 = `min((it-3),2)/2`， 我们希望3-5秒逐渐增加放大倍率，5-7秒保持倍率，因此，这个比例实际上是个时间比例，  
//		分母为2s(代表3-5s这个区间)，分子为输入帧时间戳和第3秒的差，当it=5时，我们不需要继续放大了，就使用min函数给定了一个上限2，所以分子为`min((it-3),2)`  
// 参数2：s='hd1080'  
//		s参数指定了输出帧的分辨率  
// 参数3：d=1  
//		d参数指定了每个输入帧生成多少个输出帧，我们希望视频在播放过程中对每个画面放大，那么设置为每个输入帧输出1个帧即可  
// 参数4：fps=30  
// 		fps参数指定的是输出视频帧率，如果d设置为1且输出帧率比原帧率大，则视频整体会有一种快放的效果，fps无法使用表达式，只能是个固定值  
// 参数5：`x='480-(iw/zoom/2)'`   `y='540-(ih/zoom/2)`  
//		x和y是放大窗口的左上角位置，想象一下zoompan的放大过程，它先在视频画面上划定一个矩形，然后把这个矩形的长宽按我们指定的倍率拉伸  
//		那么显然，我们就能得到放大窗口的长宽分别是iw/zoom，和ih/zoom，其中iw和ih是输入帧的宽和高，zoom是我们刚才算出来的当前放大倍率  
//		放大后，zoompan会移动画面，将放大窗口的中心点置于画面中心，由于x和y的值会动态变化，因此，中心点的移动也是一个渐进的过程  
// 说明：x和y（即缩放窗口左上角坐标）的值如果超出画面，会被ffmpeg矫正到画面内（这点很容易理解，画面内的东西才能被缩放，画面外什么都没有，没东西可缩放），  
// 画面中有些地方是永远不可能移动到画面中央的，想象一下，当缩放窗口紧贴着画面边缘的时候，缩放窗口被放大后（和原画面一样大），缩放窗口中心点刚好在画面中心点  
// 所以窗口中心点再往外的位置是不可能移动到画面中央的，而且放大倍率越小，可移动的区域就越小  

// 如果我们想让放大中心点放大后位置不移动，可以求解一个简单的方程  
// 设缩放窗口的中心点坐标为xc,yc，我们希望的放大中心点为x,y，放大后，xc，yc会移动到w/2,h/2，x,y放大后位置还是x,y  
// 那么有这个关系  
// `zoom*(x-xc) = x-w/2, zoom*(y-yc)= y-h/2`  
// 可得：`xc=x-((x-w/2)/zoom)`, `yc=y-((y-h/2)/zoom)`  
// 最终可得放大窗口左上角的坐标：`x-((x-w/2)/zoom)-(w/zoom/2)`，`y-((y-h/2)/zoom)-(h/zoom/2)`  
// 即：`x*(1-1/zoom),y*(1-1-zoom)`  

以下是完整的命令
`./ffmpeg.exe -hwaccel cuda -c:v h264 -i "D:\test\video\2024-08-27_14-12-25\hl_2024-08-27_14-21-29.mp4" -i "D:\test\icons8-star-48.png" -filter_complex "[0][1]overlay=main_w/4-24:main_h/2-24[o1];[o1]zoompan=zoom='if(between(it, 3, 7),min((it-3),2)/2*3+1,1)':s='hd1080':d=1:fps=30:x='iw/4*(1-1/zoom)':y='ih/2*(1-1/zoom)'[o];" -map "[o]" -y  -c:v h264_nvenc -cq 23 -profile:v high -pix_fmt yuv420p "D:\test\e0.mp4"`


## 从视频中提取帧

fps指定了提取视频帧的帧率，`ffmpeg.exe -i "D:\test\video\effects\e ffect1.webm" -vf "fps=1" frame%04d.png`

## 将视频的透明通道转换为灰度视频

`ffmpeg.exe -c:v libvpx-vp9 -i "C:\Users\Administrator\Downloads\chaoxianshi 02_word_ok.webm" -vf "alphaextract,format=rgba" effect2.mp4`

## 使用overlay滤镜同时叠加多个视频

官方示例：`ffmpeg -i input -i logo1 -i logo2 -filter_complex 'overlay=x=10:y=H-h-10,overlay=x=W-w-10:y=H-h-10' output`

`./ffmpeg.exe -hwaccel cuda -c:v h264  -i "D:\test\test_30fps_2min20s.mp4"  -c:v libvpx-vp9  -itsoffset 2000ms -i "D:\test\materials\effects\kill\e ffect9.webm" -c:v libvpx-vp9  -itsoffset 6000ms -i "D:\test\materials\effects\kill\e ffect9.webm" -c:v libvpx-vp9  -itsoffset 10000ms -i "D:\test\materials\effects\kill\e ffect9.webm"  -c:v libvpx-vp9  -itsoffset 14000ms -i "D:\test\materials\effects\kill\e ffect9.webm"  -c:v libvpx-vp9  -itsoffset 18000ms -i "D:\test\materials\effects\kill\e ffect9.webm"   -c:v libvpx-vp9  -itsoffset 22000ms -i "D:\test\materials\effects\kill\e ffect9.webm"   -c:v libvpx-vp9  -itsoffset 26000ms -i "D:\test\materials\effects\kill\e ffect9.webm"  -c:v libvpx-vp9  -itsoffset 30000ms -i "D:\test\materials\effects\kill\e ffect9.webm"  -c:v libvpx-vp9  -itsoffset 34000ms -i "D:\test\materials\effects\kill\e ffect9.webm"  -c:v libvpx-vp9  -itsoffset 38000ms -i "D:\test\materials\effects\kill\e ffect9.webm" -filter_complex "[0][1] overlay=alpha=1:eof_action=pass,overlay=alpha=1:eof_action=pass,overlay=alpha=1:eof_action=pass,overlay=alpha=1:eof_action=pass,overlay=alpha=1:eof_action=pass,overlay=alpha=1:eof_action=pass,overlay=alpha=1:eof_action=pass,overlay=alpha=1:eof_action=pass,overlay=alpha=1:eof_action=pass,overlay=alpha=1:eof_action=pass[o1];"  -map "[o1]"  -y  -c:v h264_nvenc -cq 23 -profile:v high -pix_fmt yuv420p  -r 30  "D:\test\test_videotrans.mp4"`

## 为视频生成透明通道（mov版和webm版）

以下是两段python程序，拼接了两个ffmpeg命令行

```python
//def add_alpha_to_effect_qtrle_mov(ffmpeg:str, input : str, outputPath : str = g_outputPath) :
    file_name = os.path.basename(input)
    name, _ = os.path.splitext(file_name)
    output = os.path.join(outputPath, name + '.mov')

    command = \
    f"{ffmpeg}\
    -i \"{input}\" \
    -filter_complex \
    \"[0]split[m][a];[a] geq = 'if(gt(lum(X,Y),16),255,0)', hue = s = 0[al];[m][al]alphamerge[ovr];\" \
     -map \"[ovr]\" -c:v qtrle -y \"{output}\""
    run_ffmpeg(command)

    def add_alpha_to_effect_vp9_webm(ffmpeg:str, input : str, outputPath : str = g_outputPath) :
    file_name = os.path.basename(input)
    name, _ = os.path.splitext(file_name)
    output = os.path.join(outputPath, name + '.webm')

    command = \
    f"{ffmpeg}\
    -i \"{input}\" \
    -filter_complex \
    \"[0]split[m][a];[a] geq = 'if(gt(lum(X,Y),16),255,0)', hue = s = 0[al];[m][al]alphamerge[ovr];\" \
     -map \"[ovr]\" -c:v vp9 -pix_fmt yuva420p -y \"{output}\""
    run_ffmpeg(command)
```

## 在视频上写字

`.\ffmpeg -an -i "D:\test\1920_1080.mp4" -vf "drawtext=fontfile='C\:\\Windows\\Fonts\\arial.ttf':text=%{n}:fontsize=72:r=60:x=(w-tw)/2: y=h-(2*lh):fontcolor=white:box=1:boxcolor=0x00000099" -r 30 -y D:\test\sample.mp4`

## 视频从第五秒开始两倍速快放

用setpts滤镜加速视频后，实际帧率会翻倍，因此ffmpeg在生成视频时会丢掉一些帧

`.\ffmpeg -an -i "D:\test\sample.mp4" -filter:v "setpts='if(gt(T, 5), 0.5*(PTS+(5/TB)), PTS)'" -r 30 -y "D:\test\test_speedup.mp4"`

## 反复快慢放视频

- var 0: 距特效开始的帧数
- var 1: PREV_OUTPTS
- var 2: PREV_INPTS
- var 3: 快放倍率
- pts计算公式：PREV_OUTPTS + (PTS - PREV_INPTS) * 倍率

```bash
.\ffmpeg - an - i "D:\test\sample.mp4" - filter:v "setpts=expr='st(0,N-5*FR);st(1,ifnot(isnan(PREV_OUTPTS), PREV_OUTPTS));st(2,ifnot(isnan(PREV_INPTS),PREV_INPTS)); \
st(3, \
if( gte(ld(0),0)*lt(ld(0),20), lerp(1, 0.2, ld(0)/20), \
if(gte(ld(0),20)*lt(ld(0),40), lerp(0.2, 1, (ld(0)-20)/20), \
if(gte(ld(0),40)*lt(ld(0),60), lerp(1, 2, (ld(0)-40)/20), \
if(gte(ld(0),60)*lt(ld(0),80), lerp(2, 1, (ld(0)-60)/20), \
if(gte(ld(0),80)*lt(ld(0),100), lerp(1, 0.2, (ld(0)-80)/20), \
if(gte(ld(0),100)*lt(ld(0),120), lerp(0.2, 1, (ld(0)-100)/20), 1) \
)))))); print(ld(3));print(PTS);print(ld(1)+(PTS-ld(2))*ld(3))' " - r 30 - y "D:\test\test_pts2.mp4" > D:\test\fflog.log 2 > &1
```

## 插帧

minterpolate

## 拼接视频（concat）
        
参考 [https://trac.ffmpeg.org/wiki/Concatenate](https://trac.ffmpeg.org/wiki/Concatenate)

### 1. concat 滤镜

可用来拼接不同分辨率，不同编码的视频

```bash
ffmpeg -i "v1.mp4"  -i "v2.mp4" -filter_complex "[0:v][1:v]concat=n=2:v=1[out]" -map "[out]" -y "output.mp4"
```

### 2. concat demuxer

concat demuxer工作在视频流这一级别，输入视频可以有不同的封装格式，但视频编码和编码参数必须相同

首先要将要输入视频以下面的格式写入一个文本文件

```txt
file '/path/to/file1.mp4'
file '/path/to/file2.mp4'
file '/path/to/file3.mp4'
```

然后

```bash
ffmpeg -f concat -safe 0 -i mylist.txt -c copy output.wav
```

（如果视频路径是相对路径，则不需要`-safe 0`参数）

### 3. concat protocol

concat protocol工作在文件级别，只能用来拼接特定编码格式的视频，例如MPEG-2 TS文件，

```bash
ffmpeg -i "concat:input1.ts|input2.ts|input3.ts" -c copy output.ts
```

如果要拼接h264编码的视频，需要现将视频重新封装成ts格式，再进行拼接

```bash
ffmpeg -i input1.mp4 -c copy intermediate1.ts
ffmpeg -i input2.mp4 -c copy intermediate2.ts
ffmpeg -i "concat:intermediate1.ts|intermediate2.ts" -c copy output.mp4
```

也可以使用命名管道避免创建中间文件

```bash
mkfifo temp1 temp2
ffmpeg -y -i input1.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts temp1 2> /dev/null & \\
ffmpeg -y -i input2.mp4 -c copy -bsf:v h264_mp4toannexb -f mpegts temp2 2> /dev/null & \\
ffmpeg -f mpegts -i "concat:temp1|temp2" -c copy -bsf:a aac_adtstoasc output.mp4
```

## 剪切视频

参数说明：
- `-ss`:起始时间
- `-t`:持续时间
- `-to`:结束时间
- `-t`和`-to`同时使用时，`-t`优先
- `-ss`，`-t`，`-to`即可用作输入参数，也可用作输出参数
- 时间默认是秒，ffmpeg的时间格式可参考[https://ffmpeg.org/ffmpeg-utils.html#time-duration-syntax](https://ffmpeg.org/ffmpeg-utils.html#time-duration-syntax)

```bash
ffmpeg -ss 2 -t 5 -to 10 -i input.mp4 -c copy output.mp4
```
"""

## 控制解码速度

`readrate n`，n为浮点数，代表每秒读取原始多少秒的输入，如果要按原始帧率去读取，n设置为1即可

```bash
.\ffmpeg -hwaccel cuda -c:v h264 -readrate 0.5 -i D:\test\4k_30min.mp4 -c:v h264_nvenc -cq 20 -y D:\test\gpu_encode.mp4
```

## 录屏并生成视频

`ffmpeg -f gdigrab -framerate 30 -i desktop -c:v libx264 -pix_fmt yuv420p output.mp4`
