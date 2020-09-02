_SHA1to80 proc uses eax ebx ecx edx lpMemory
     local @aa,@bb,@cc,@dd,@ee
     
   ;  Extend the sixteen 32-bit words into eighty 32-bit words:
     mov eax,offset _Hash_Sha1_w
     xor ecx,ecx
     mov edx,lpMemory
     .while ecx<=15
       mov bl,[edx+ecx*4+3]
       mov [eax+ecx*4],bl
       mov bl,[edx+ecx*4+2]
       mov [eax+ecx*4+1],bl
       mov bl,[edx+ecx*4+1]
       mov [eax+ecx*4+2],bl
       mov bl,[edx+ecx*4]
       mov [eax+ecx*4+3],bl
       inc ecx
     .endw
     .while ecx<=79
        mov ebx,[eax+ecx*4-16*4]
        xor ebx,[eax+ecx*4-14*4]
        xor ebx,[eax+ecx*4-8*4]
        xor ebx,[eax+ecx*4-3*4]
        rol ebx,1
        mov [eax+ecx*4],ebx
        inc ecx
     .endw
     
      ; Initialize hash value for this chunk:
     mov ebx,offset state_sha1
     push dword ptr [ebx]
     pop @aa
     push dword ptr [ebx+4]
     pop @bb
     push dword ptr [ebx+8]
     pop @cc
     push dword ptr [ebx+12]
     pop @dd
     push dword ptr [ebx+16]
     pop @ee
     
    ; Main loop:
     xor ecx,ecx
     .while ecx<=79
         .if ecx<=19
            mov ebx,@bb
            and ebx,@cc
            mov edx,@bb
            not edx
            and edx,@dd
            or ebx,edx
            add ebx,5A827999h
         .elseif ecx>= 40 && ecx <= 59
            mov ebx,@bb
            and ebx,@cc
            mov edx,@bb
            and edx,@dd
            or ebx,edx
            mov edx,@cc
            and edx,@dd
            or ebx,edx
            add ebx,8F1BBCDCh
          .else
              mov ebx,@bb
              xor ebx,@cc
              xor ebx,@dd
              .if ecx<=39
                 add ebx,6ED9EBA1h
              .else
                 add ebx,0CA62C1D6h
               .endif
           .endif
           mov edx,@aa             ;edx表示temp,ebx表示f+k
           rol edx,5
           add edx,ebx
           add edx,@ee
           mov eax,offset _Hash_Sha1_w
           add edx,[eax+ecx*4]
           push @dd
           pop @ee
           push @cc
           pop @dd
           mov ebx,@bb
           rol ebx,30
           mov @cc,ebx
           push @aa
           pop @bb
           mov @aa,edx
      inc ecx
      .endw
      
      mov ebx,offset state_sha1
      mov edx,@aa
      add dword ptr [ebx],edx
      mov edx,@bb
      add dword ptr [ebx+4],edx
      mov edx,@cc
      add dword ptr [ebx+8],edx
      mov edx,@dd
      add dword ptr [ebx+12],edx
      mov edx,@ee
      add dword ptr [ebx+16],edx
           
     ret
_SHA1to80  endp
     