################################################################################
#                                                                              #
#                                  VARIABLES                                   #
#                                                                              #
################################################################################

##############################
#	Path
##############################

GNL_Path="../GNL/"

LD_Path="detector_leak/"

FILE_Path="file/"

##############################
#	Files
##############################

ld_file="${LD_Path}leak_detector.c"

file_man_part="${FILE_Path}fd_Simple_Input ${FILE_Path}fd_Line_Length \
	${FILE_Path}fd_Empty_Line ${FILE_Path}fd_One_Line \
	${FILE_Path}fd_Empty_File ${FILE_Path}fd_Null_End"

gnl_files="${GNL_Path}get_next_line.c ${GNL_Path}get_next_line_utils.c"

gnl_bonus_files="${GNL_Path}get_next_line_bonus.c ${GNL_Path}get_next_line_utils_bonus.c"

man_test_file="gnl_test_mandatory.c"

invalid_fd="gnl_test_invalid_fd.c"

invalid_buf_size="gnl_test_invalid_buffer_size.c"

bonus_test="gnl_test_bonus.c"

##############################
#	Colors
##############################

White='\033[0;39m'
BUWhite='\e[1;4m'
BRed='\033[1;31m'
BGreen='\033[1;92m'
BYellow='\033[1;93m'
BBlue='\033[1;34m'
BBlueL='\e[1;94m'
BUBlue='\e[1;4;34m'
BUCyan='\e[1;4;36m'
BGrey='\e[1;90m'
BMagenta='\e[1;35m'

################################################################################
#                                                                              #
#                                  FUNCTIONS                                   #
#                                                                              #
################################################################################

function print_ok {
	echo -e -n "$BGreen[OK]$White"
}

function print_ko {
	echo -e -n "$BRed[KO]$White"
}

function print_no_leak {
	echo -e -n "$BGrey[NO_LK]$White"
}

function print_leak {
	echo -e -n "$BYellow[LEAKS]$White"
}

function print_er {
	echo -e -n "${BYellow}[Er]${white}"
}

function print_error {
	echo -e -n "${BYellow}[Error]${White}"
}

function is_int {
	re='^[0-9]+$'
	if ! [[ $1 =~ $re ]]; then
		#is not an integer
		return 0
	else
		#is an integer
		return 1
	fi
}

function launch_norminette {
	echo -e "${BUBlue}Run norminette:${White} "
	norminette ${GNL_Path}* > /dev/null
	if [ $? = 127 ]; then
		echo -e "        ${BYellow}[NOT_FOUND]${White}"
	elif [ $? = 0 ]; then
		echo -e "        ${BGreen}[OK]${White}"
	elif [ $? = 1 ]; then
		echo -e "        ${BRed}[KO]${White}"
	fi
	echo -e ""
}

##############################
#	Table Functions
##############################

function table_empty {
	echo -e "                    |             |"
}

function table_header {
	echo -e "        ${BMagenta}BUFFER_SIZE${White} | ${BBlueL}Result test${White} |  ${BYellow}Leaks${White}"
	table_empty
}

function table_line {
	is_int "$1"
	if [ $? = 1 ]; then
		len_nb=${#1}
		for (( i=0; i<$((8 + (11 - $len_nb) / 2)); i++ )); do
			echo -e -n " "
		done
		echo -e -n "$1"
		if [ $(($len_nb%2)) = 1 ]; then
			nb_space=$(((11 - $len_nb) / 2 + 1))
		else
			nb_space=$(((11 - $len_nb) / 2 + 2))
		fi
		for (( i=0; i<$nb_space; i++ )); do
			echo -e -n " "
		done
		echo -e -n "|    "
		if [ $2 = 0 ] || [ $2 = 4 ]; then
			print_ok
		elif [ $2 = 1 ] || [ $2 = 3 ]; then
			print_ko
		else
			print_er
		fi
		echo -e -n "     | "
		if [ $2 = 3 ] || [ $2 = 4 ]; then
			print_leak
			echo -e -n "\n"
		elif [ $2 = 0 ] || [ $2 = 1 ]; then
			print_no_leak
			echo -e -n "\n"
		else
			print_error
			echo -e -n "\n"
		fi
		table_empty
	else
		echo -e "${BYellow}Error BUFFER_SIZE${White}"
	fi
}

##############################
#	Mandatory Functions
##############################

function check_man_file {
	if [ -e "${GNL_Path}get_next_line.c" ] && [ -e "${GNL_Path}get_next_line_utils.c" ] && [ -e "${GNL_Path}get_next_line.h" ]; then
		echo -e "        ${BGrey}Files exist${White}\n"
	else
		echo -e "        ${BRed}The files of mandatory part do not exist${White}"
		exit 1
	fi
}

function compile_man_test {
	is_int "$1"
	if [ $? = 1 ]; then
		gcc -Wall -Wextra -Werror ${gnl_files} ${ld_file} ${man_test_file} -I${GNL_Path} -I${LD_Path} -I. -D BUFFER_SIZE=$1 -o man_test_part1
	else
		gcc -Wall -Wextra -Werror ${gnl_files} ${ld_file} ${man_test_file} -I${GNL_Path} -I${LD_Path} -I. -o man_test_part1
	fi
}

function test_file {
	if [ -e "$1" ]; then
		echo -e -n "${BUCyan}Test with "
		echo -e "$1:${White}\n" | cut -c 9-
		table_header
		compile_man_test 1
		./man_test_part1 "$1"
		table_line 1 $?
		compile_man_test 10
		./man_test_part1 "$1"
		table_line 10 $?
		compile_man_test 42
		./man_test_part1 "$1"
		table_line 42 $?
		compile_man_test 65535
		./man_test_part1 "$1"
		table_line 65535 $?
		rand_nb=$RANDOM
		compile_man_test $rand_nb
		./man_test_part1 "$1"
		table_line $rand_nb $?
	else
		echo -e "${BYellow}Error name file\n$1 does not exist${White}"
	fi
}

function compile_invalid_fd {
	is_int "$1"
	if [ $? = 1 ]; then
		is_int "$2"
		if [ $? = 1 ]; then
			gcc -Wall -Wextra -Werror ${gnl_files} ${ld_file} ${invalid_fd} -I${GNL_Path} -I${LD_Path} -I. -D NB_CALL_GET_NEXT_LINE=$1 -D BUFFER_SIZE=$2 -o test_invalid_fd
		else
			gcc -Wall -Wextra -Werror ${gnl_files} ${ld_file} ${invalid_fd} -I${GNL_Path} -I${LD_Path} -I. -D NB_CALL_GET_NEXT_LINE=$1 -o test_invalid_fd
		fi
	else
		gcc -Wall -Wextra -Werror ${gnl_files} ${ld_file} ${invalid_fd} -I${GNL_Path} -I${LD_Path} -I. -o test_invalid_fd
	fi
}

function tests_invalid_fd {
	echo -e "\n"
	echo -e "${BUCyan}Test invalid fd:${White}\n"
	table_header
	compile_invalid_fd 1 42
	./test_invalid_fd
	table_line 42 $?
	compile_invalid_fd 42 42
	./test_invalid_fd
	table_line 42 $?
	compile_invalid_fd 42 1
	./test_invalid_fd
	table_line 1 $?
	compile_invalid_fd 12 10
	./test_invalid_fd
	table_line 10 $?
}

function compile_invalid_buf_size {
	is_int $1
	if [ $? = 1 ]; then
		gcc -Wall -Wextra -Werror ${gnl_files} ${ld_file} ${invalid_buf_size} -I${GNL_Path} -I${LD_Path} -I. -D BUFFER_SIZE=$1 -o test_invalid_buf_size
	else
		gcc -Wall -Wextra -Werror ${gnl_files} ${ld_file} ${invalid_buf_size} -I${GNL_Path} -I${LD_Path} -I. -o test_invalid_buf_size
	fi
}

function tests_invalid_buf_size {
	echo -e "\n"
	echo -e "${BUCyan}Test invalid BUFFER_SIZE:${White}\n"
	table_header
	compile_invalid_buf_size 0
	./test_invalid_buf_size
	table_line 0 $?
}

function compile_read_not_in_full {
	is_int $1
	if [ $? = 1 ]; then
		is_int $2
		if [ $? = 1 ]; then
			gcc -Wall -Wextra -Werror ${gnl_files} ${man_test_file} ${ld_file} -I${GNL_Path} -I${LD_Path} -D NB_CALL_GET_NEXT_LINE=$1 -D BUFFER_SIZE=$2 -o test_rnif
		else
			gcc -Wall -Wextra -Werror ${gnl_files} ${man_test_file} ${ld_file} -I${GNL_Path} -I${LD_Path} -D NB_CALL_GET_NEXT_LINE=$1 -o test_rnif
		fi
	else
			gcc -Wall -Wextra -Werror ${gnl_files} ${man_test_file} ${ld_file} -I${GNL_Path} -I${LD_Path} -o test_rnif
	fi
}

function check_read_not_in_full {
	echo -e "\n"
	echo -e "${BUCyan}Test read_not_in_full:${White}\n"
	table_header
	compile_read_not_in_full 1 42
	./test_rnif "file/fd_Simple_Input"
	table_line 42 $?
	compile_read_not_in_full 5 42
	./test_rnif "file/fd_Simple_Input"
	table_line 42 $?
	compile_read_not_in_full 5 10
	./test_rnif "file/fd_Simple_Input"
	table_line 10 $?
	compile_read_not_in_full 3 1
	./test_rnif "file/fd_Simple_Input"
	table_line 1 $?
}

function mandatory_test {
	echo -e "${BUBlue}Tests for mandatory part:${White}\n"
	check_man_file
	for file in ${file_man_part}
	do
		test_file "$file"
		echo -e "\n"
	done
	rm -f man_test_part1
	check_read_not_in_full
	rm -f test_rnif
	tests_invalid_fd
	rm -f test_invalid_fd
	tests_invalid_buf_size
	rm -f test_invalid_buf_size
}

##############################
#	Bonus Functions
##############################

function check_bonus_file {
	if [ -e "${GNL_Path}get_next_line_bonus.c" ] && [ -e "${GNL_Path}get_next_line_utils_bonus.c" ] && [ -e "${GNL_Path}get_next_line_bonus.h" ]; then
		echo -e "        ${BGrey}Files exist${White}\n"
	else
		echo -e "        ${BRed}The files of bonus part do not exist${White}\n"
		exit 1
	fi
}

function compile_bonus {
	is_int $1
	if [ $? = 1 ]; then
		is_int $2
		if [ $? = 1 ]; then
			gcc -Wall -Wextra -Werror ${gnl_bonus_files} ${bonus_test} ${ld_file} -I${GNL_Path} -I${LD_Path} -D NB_CALL_GET_NEXT_LINE=$1 -D BUFFER_SIZE=$2 -o test_bonus
		else
			gcc -Wall -Wextra -Werror ${gnl_bonus_files} ${bonus_test} ${ld_file} -I${GNL_Path} -I${LD_Path} -D NB_CALL_GET_NEXT_LINE=$1 -o test_bonus
		fi
	else
		gcc -Wall -Wextra -Werror ${gnl_bonus_files} ${bonus_test} ${ld_file} -I${GNL_Path} -I${LD_Path} -o test_bonus
	fi
}

function random_bonus_test {
	echo -e "\n${BUCyan}Random test with 6 file descriptor:${White}"
	for (( i=0; i<30; i++ ))
	do
		rand_call=$(($RANDOM % 100 + 1))
		rand_buf=$(($RANDOM % 100 + 1))
		if [ $((i%5)) = 0 ]; then
			echo -e -n "\n        "
		fi
		compile_bonus $rand_call $rand_buf
		./test_bonus
		if [ $? = 0 ] || [ $? = 4 ]; then
			print_ok
		elif [ $? = 1 ] || [ $? = 3 ]; then
			print_ko
		else
			print_er
		fi
		echo -e -n " "
		if [ $? = 3 ] || [ $? = 4 ]; then
			print_leak
		elif [ $? = 0 ] || [ $? = 1 ]; then
			print_no_leak
		else
			print_error
		fi
		echo -e -n " "
	done
	echo -e "\n"
}

function check_one_static {
	echo -e "${BUCyan}One static variable:${White}\n"
	echo -e -n "        "
	nb_static_variable=$(cat ${GNL_Path}get_next_line_bonus.c | grep "static" | wc -l)
	if [ $nb_static_variable = 1 ]; then
		print_ok
	else
		print_ko
	fi
	echo ""
}

function bonus_test {
	echo -e "${BUBlue}Tests for bonus part:${White}\n"
	check_bonus_file
	check_one_static
	random_bonus_test
	rm -f test_bonus
}

################################################################################
#                                                                              #
#                                   SCRIPT                                     #
#                                                                              #
################################################################################
clear
launch_norminette
if [ "$1" = "m" ]; then
	mandatory_test
elif [ "$1" = "b" ]; then
	bonus_test
else
	mandatory_test
	echo -e "\n\n"
	bonus_test
fi
