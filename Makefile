SRCS_DIR = srcs
BONUS_DIR = bonus
OBJ_DIR = obj
NAME = libasm.a
CC = nasm
FLAGS = -f elf64
AR = ar rcs
RM = rm -rf

SRCS = $(SRCS_DIR)/ft_read.s \
       $(SRCS_DIR)/ft_strcmp.s \
       $(SRCS_DIR)/ft_strcpy.s \
       $(SRCS_DIR)/ft_strdup.s \
       $(SRCS_DIR)/ft_strlen.s \
       $(SRCS_DIR)/ft_write.s

OBJS = $(SRCS:$(SRCS_DIR)/%.s=$(OBJ_DIR)/%.o)

all: $(OBJ_DIR) $(NAME)

$(OBJ_DIR):
	mkdir -p $(OBJ_DIR)

$(OBJ_DIR)/%.o: $(SRCS_DIR)/%.s
	$(CC) $(FLAGS) $< -o $@

$(NAME): $(OBJS)
	$(AR) $(NAME) $(OBJS)

clean:
	$(RM) $(OBJ_DIR)

fclean: clean
	$(RM) $(NAME)

re: fclean all

.PHONY: all clean fclean re bonus