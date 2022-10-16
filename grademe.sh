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

bonus_test="gnl_test_bonus.c"

##############################
#	Colors
##############################

White='\033[0;37m'
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
	echo -e "$BGrey[NO_LK]$White"
}

function print_leak {
	echo -e "$BYellow[LEAKS]$White"
}

function print_er {
	echo -e -n "${BYellow}[Er]${white}"
}

function print_error {
	echo -e "${BYellow}[Error]${White}"
}

function is_int {
	re='^[0-9]+$'
	if ! [[ $1 =~ $re ]] ; then
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
		echo -e "     ${BYellow}[NOT_FOUND]${White}"
	elif [ $? = 0 ]; then
		echo -e "     ${BGreen}[OK]${White}"
	elif [ $? = 1 ]; then
		echo -e "     ${BRed}[KO]${White}"
	fi
	echo -e "\n"
}

##############################
#	Table Functions
##############################

function table_empty {
	echo -e "                |             |"
}

function table_header {
	echo -e "    ${BMagenta}BUFFER_SIZE${White} | ${BBlueL}Result test${White} |  ${BYellow}Leaks${White}"
	table_empty
}

function table_line {
	is_int "$1"
	if [ $? = 1 ]; then
		len_nb=${#1}
		for (( i=0; i<$((4 + (11 - $len_nb) / 2)); i++ )); do
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
		elif [ $2 = 0 ] || [ $2 = 1 ]; then
			print_no_leak
		else
			print_error
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
		echo -e "${BGrey}Files exist${White}\n"
	else
		echo -e "${BRed}The files of mandatory part do not exist${White}"
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
		echo -e "\n"
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

function mandatory_test {
	echo -e "${BUBlue}Tests for mandatory part:${White}\n"
	check_man_file
	for file in ${file_man_part}
	do
		test_file "$file"
		echo -e "\n"
	done
	rm -f man_test_part1
}

##############################
#	Bonus Functions
##############################

function check_bonus_file {
	if [ -e "${GNL_Path}get_next_line_bonus.c" ] && [ -e "${GNL_Path}get_next_line_utils_bonus.c" ] && [ -e "${GNL_Path}get_next_line_bonus.h" ]; then
		echo -e "${BGrey}Files exist${White}\n"
	else
		echo -e "${BRed}The files of bonus part do not exist${White}"
		exit 1
	fi
}

function bonus_test {
	echo -e "${BUBlue}Tests for bonus part:${White}\n"
	check_man_file
}

################################################################################
#                                                                              #
#                                   SCRIPT                                     #
#                                                                              #
################################################################################
clear
if [ "$1" = "m" ]; then
	launch_norminette
	mandatory_test
elif [ "$1" = "b" ]; then
	launch_norminette
	bonus_test
else
	launch_norminette
	mandatory_test
	echo -e "\n\n"
	bonus_test
fi
