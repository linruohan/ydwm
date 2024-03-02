#!/bin/bash
# DWM自启动脚本 仅作参考
# 搭配 https://github.com/yaocccc/scripts 仓库使用 目录位置 $DWM/scripts
# 部分配置文件在 $DWM/scripts/config 目录下

_thisdir=$(
    cd "$(dirname "$0")" || return
    pwd
)

settings() {
    [ "$1" ] && sleep "$1"
    # xset -b # 关闭蜂鸣器
    # syndaemon -i 1 -t -K -R -d       # 设置使用键盘时触控板短暂失效
    # "$DWM/"scripts/set_screen.sh one # 设置显示器
}

daemons() {
    [ $1 ] && sleep $1
    "$_thisdir/statusbar/statusbar.sh" cron & # 开启状态栏定时更新
    # xss-lock -- $DWM/scripts/blurlock.sh &                                                    # 开启自动锁屏程序
    fcitx5 & # 开启输入法
    # lemonade server &                                                                         # 开启lemonade 远程剪切板支持
    flameshot &                                                                               # 截图要跑一个程序在后台 不然无法将截图保存到剪贴板
    dunst -conf $DWM/scripts/config/dunst.conf &                                              # 开启通知server
    picom --experimental-backends --config $DWM/scripts/config/picom.conf >> /dev/null 2>&1 & # 开启picom
    xrandr --output LVDS-1 --off --output DP-1 --off --output HDMI-1 --primary --mode 1920x1080 --pos 0x0 --rotate normal --output VGA-1-1 --off
    feh --bg-fill --randomize ~/Pictures/guidao/*
}

cron() {
    [ $1 ] && sleep $1
    let i=10
    while true; do
        [ $((i % 10)) -eq 0 ] && $DWM/scripts/set_screen.sh check                      # 每10秒检查显示器状态 以此自动设置显示器
        [ $((i % 300)) -eq 0 ] && feh --randomize --bg-fill ~/Pictures/wallpaper/*.png # 每300秒更新壁纸
        sleep 10
        let i+=10
    done
}

# settings 1 & # 初始化设置项
daemons 3 & # 后台程序项
# cron 5 &     # 定时任务项
