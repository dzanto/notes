---
title: "Firewalld"
summary: List of Front Matter variables used by PaperMod
date: 2023-05-27
tags: [linux, firewalld]
categories: ["linux"]
author: "Aditya Telange"
draft: false
# weight: 5
---
firewall-cmd --list-all

firewall-cmd --permanent --zone=public --add-port=1313/tcp
firewall-cmd --permanent --zone=public --remove-port=1313/tcp
firewall-cmd --reload

firewall-cmd --add-port=1313/tcp  --permanent


Разобраться с зонами