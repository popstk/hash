OBJS = $(NAME).obj
RES  = $(NAME).res

LINK_FLAG = /subsystem:windows
ML_FLAG = /c /coff

all: Hash

Hash: Hash.obj Hash.res
	Link $(LINK_FLAG) Hash.obj Hash.res

.asm.obj:
	ml $(ML_FLAG) $<
.rc.res:
	rc $<

clean:
	del Hash.obj
	del Hash.res
