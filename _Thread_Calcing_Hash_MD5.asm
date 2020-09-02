;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;Hash中md5的部分循环
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
_FF proc ta,tb,tc,td,M,ts,k
      mov eax,tb    ;F(tb,tc,td)
      mov ecx,eax
      and eax,tc
      not ecx
      and ecx,td
      or eax,ecx

      add eax,ta
      add eax,M
      add eax,k
      mov ecx,ts
      rol eax,cl
      add eax,tb
      ret
_FF endp
_GG proc ta,tb,tc,td,M,ts,k
      mov eax,td     ;G(tb,tc,td)
      mov ecx,eax
      and eax,tb
      not ecx
      and ecx,tc
      or eax,ecx

      add eax,ta
      add eax,M
      add eax,k
      mov ecx,ts
      rol eax,cl
      add eax,tb
      ret
_GG endp
_HH proc ta,tb,tc,td,M,ts,k
      mov eax,tb        ;H(tb,tc,td)
      xor eax,tc
      xor eax,td

      add eax,ta
      add eax,M
      add eax,k
      mov ecx,ts
      rol eax,cl
      add eax,tb
      ret
_HH endp
_II proc ta,tb,tc,td,M,ts,k
      mov eax,td       ;I(tb,tc,td)
      not eax
      or eax,tb
      xor eax,tc

      add eax,ta
      add eax,M
      add eax,k
      mov ecx,ts
      rol eax,cl
      add eax,tb
      ret
_II endp
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>		

;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
;_MD5to64  ebx，edx固定分配作state_md5和带变换的字符lpMemory
;>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>		
_MD5to64 proc uses eax ebx ecx edx lpMemory
     local @aa,@bb,@cc,@dd          
                                            
     mov ebx,offset state_md5
     mov edx,lpMemory        
     push dword ptr [ebx]
     pop @aa
     push dword ptr [ebx+4]
     pop @bb
     push dword ptr [ebx+8]
     pop @cc
     push dword ptr [ebx+12]
     pop @dd

     invoke _FF,@aa,@bb,@cc,@dd,[edx+0],7,0d76aa478h;第1轮
     mov @aa,eax
     invoke _FF,@dd,@aa,@bb,@cc,[edx+4],12,0e8c7b756h;第2轮
     mov @dd,eax
     invoke _FF,@cc,@dd,@aa,@bb,[edx+8],17,0242070dbh;第3轮
     mov @cc,eax
     invoke _FF,@bb,@cc,@dd,@aa,[edx+12],22,0c1bdceeeh;第4轮
     mov @bb,eax
     invoke _FF,@aa,@bb,@cc,@dd,[edx+16],7,0f57c0fafh;第5轮
     mov @aa,eax
     invoke _FF,@dd,@aa,@bb,@cc,[edx+20],12,04787c62ah;第6轮
     mov @dd,eax
     invoke _FF,@cc,@dd,@aa,@bb,[edx+24],17,0a8304613h;第7轮
     mov @cc,eax
     invoke _FF,@bb,@cc,@dd,@aa,[edx+28],22,0fd469501h;第8轮
     mov @bb,eax
     invoke _FF,@aa,@bb,@cc,@dd,[edx+32],7,0698098d8h;第9轮
     mov @aa,eax
     invoke _FF,@dd,@aa,@bb,@cc,[edx+36],12,08b44f7afh;第10轮
     mov @dd,eax
     invoke _FF,@cc,@dd,@aa,@bb,[edx+40],17,0ffff5bb1h;第11轮
     mov @cc,eax
     invoke _FF,@bb,@cc,@dd,@aa,[edx+44],22,0895cd7beh;第12轮
     mov @bb,eax
     invoke _FF,@aa,@bb,@cc,@dd,[edx+48],7,06b901122h;第13轮
     mov @aa,eax
     invoke _FF,@dd,@aa,@bb,@cc,[edx+52],12,0fd987193h;第14轮
     mov @dd,eax
     invoke _FF,@cc,@dd,@aa,@bb,[edx+56],17,0a679438eh;第15轮
     mov @cc,eax
     invoke _FF,@bb,@cc,@dd,@aa,[edx+60],22,049b40821h;第16轮
     mov @bb,eax
     invoke _GG,@aa,@bb,@cc,@dd,[edx+4],5,0f61e2562h;第17轮
     mov @aa,eax
     invoke _GG,@dd,@aa,@bb,@cc,[edx+24],9,0c040b340h;第18轮
     mov @dd,eax
     invoke _GG,@cc,@dd,@aa,@bb,[edx+44],14,0265e5a51h;第19轮
     mov @cc,eax
     invoke _GG,@bb,@cc,@dd,@aa,[edx+0],20,0e9b6c7aah;第20轮
     mov @bb,eax
     invoke _GG,@aa,@bb,@cc,@dd,[edx+20],5,0d62f105dh;第21轮
     mov @aa,eax
     invoke _GG,@dd,@aa,@bb,@cc,[edx+40],9,002441453h;第22轮
     mov @dd,eax
     invoke _GG,@cc,@dd,@aa,@bb,[edx+60],14,0d8a1e681h;第23轮
     mov @cc,eax
     invoke _GG,@bb,@cc,@dd,@aa,[edx+16],20,0e7d3fbc8h;第24轮
     mov @bb,eax
     invoke _GG,@aa,@bb,@cc,@dd,[edx+36],5,021e1cde6h;第25轮
     mov @aa,eax
     invoke _GG,@dd,@aa,@bb,@cc,[edx+56],9,0c33707d6h;第26轮
     mov @dd,eax
     invoke _GG,@cc,@dd,@aa,@bb,[edx+12],14,0f4d50d87h;第27轮
     mov @cc,eax
     invoke _GG,@bb,@cc,@dd,@aa,[edx+32],20,0455a14edh;第28轮
     mov @bb,eax
     invoke _GG,@aa,@bb,@cc,@dd,[edx+52],5,0a9e3e905h;第29轮
     mov @aa,eax
     invoke _GG,@dd,@aa,@bb,@cc,[edx+8],9,0fcefa3f8h;第30轮
     mov @dd,eax
     invoke _GG,@cc,@dd,@aa,@bb,[edx+28],14,0676f02d9h;第31轮
     mov @cc,eax
     invoke _GG,@bb,@cc,@dd,@aa,[edx+48],20,08d2a4c8ah;第32轮
     mov @bb,eax
     invoke _HH,@aa,@bb,@cc,@dd,[edx+20],4,0fffa3942h;第33轮
     mov @aa,eax
     invoke _HH,@dd,@aa,@bb,@cc,[edx+32],11,08771f681h;第34轮
     mov @dd,eax
     invoke _HH,@cc,@dd,@aa,@bb,[edx+44],16,06d9d6122h;第35轮
     mov @cc,eax
     invoke _HH,@bb,@cc,@dd,@aa,[edx+56],23,0fde5380ch;第36轮
     mov @bb,eax
     invoke _HH,@aa,@bb,@cc,@dd,[edx+4],4,0a4beea44h;第37轮
     mov @aa,eax
     invoke _HH,@dd,@aa,@bb,@cc,[edx+16],11,04bdecfa9h;第38轮
     mov @dd,eax
     invoke _HH,@cc,@dd,@aa,@bb,[edx+28],16,0f6bb4b60h;第39轮
     mov @cc,eax
     invoke _HH,@bb,@cc,@dd,@aa,[edx+40],23,0bebfbc70h;第40轮
     mov @bb,eax
     invoke _HH,@aa,@bb,@cc,@dd,[edx+52],4,0289b7ec6h;第41轮
     mov @aa,eax
     invoke _HH,@dd,@aa,@bb,@cc,[edx+0],11,0eaa127fah;第42轮
     mov @dd,eax
     invoke _HH,@cc,@dd,@aa,@bb,[edx+12],16,0d4ef3085h;第43轮
     mov @cc,eax
     invoke _HH,@bb,@cc,@dd,@aa,[edx+24],23,004881d05h;第44轮
     mov @bb,eax
     invoke _HH,@aa,@bb,@cc,@dd,[edx+36],4,0d9d4d039h;第45轮
     mov @aa,eax
     invoke _HH,@dd,@aa,@bb,@cc,[edx+48],11,0e6db99e5h;第46轮
     mov @dd,eax
     invoke _HH,@cc,@dd,@aa,@bb,[edx+60],16,01fa27cf8h;第47轮
     mov @cc,eax
     invoke _HH,@bb,@cc,@dd,@aa,[edx+8],23,0c4ac5665h;第48轮
     mov @bb,eax
     invoke _II,@aa,@bb,@cc,@dd,[edx+0],6,0f4292244h;第49轮
     mov @aa,eax
     invoke _II,@dd,@aa,@bb,@cc,[edx+28],10,0432aff97h;第50轮
     mov @dd,eax
     invoke _II,@cc,@dd,@aa,@bb,[edx+56],15,0ab9423a7h;第51轮
     mov @cc,eax
     invoke _II,@bb,@cc,@dd,@aa,[edx+20],21,0fc93a039h;第52轮
     mov @bb,eax
     invoke _II,@aa,@bb,@cc,@dd,[edx+48],6,0655b59c3h;第53轮
     mov @aa,eax
     invoke _II,@dd,@aa,@bb,@cc,[edx+12],10,08f0ccc92h;第54轮
     mov @dd,eax
     invoke _II,@cc,@dd,@aa,@bb,[edx+40],15,0ffeff47dh;第55轮
     mov @cc,eax
     invoke _II,@bb,@cc,@dd,@aa,[edx+4],21,085845dd1h;第56轮
     mov @bb,eax
     invoke _II,@aa,@bb,@cc,@dd,[edx+32],6,06fa87e4fh;第57轮
     mov @aa,eax
     invoke _II,@dd,@aa,@bb,@cc,[edx+60],10,0fe2ce6e0h;第58轮
     mov @dd,eax
     invoke _II,@cc,@dd,@aa,@bb,[edx+24],15,0a3014314h;第59轮
     mov @cc,eax
     invoke _II,@bb,@cc,@dd,@aa,[edx+52],21,04e0811a1h;第60轮
     mov @bb,eax
     invoke _II,@aa,@bb,@cc,@dd,[edx+16],6,0f7537e82h;第61轮
     mov @aa,eax
     invoke _II,@dd,@aa,@bb,@cc,[edx+44],10,0bd3af235h;第62轮
     mov @dd,eax
     invoke _II,@cc,@dd,@aa,@bb,[edx+8],15,02ad7d2bbh;第63轮
     mov @cc,eax
     invoke _II,@bb,@cc,@dd,@aa,[edx+36],21,0eb86d391h;第64轮
     mov @bb,eax

     mov eax,@aa
     add dword ptr [ebx],eax
     mov eax,@bb
     add dword ptr [ebx+4],eax
     mov eax,@cc
     add dword ptr [ebx+8],eax
     mov eax,@dd
     add dword ptr [ebx+12],eax

     ret 
_MD5to64 endp