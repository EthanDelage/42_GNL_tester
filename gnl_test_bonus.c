/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   gnl_test_bonus.c                                   :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: edelage <edelage@student.42lyon.fr>        +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/10/16 23:21:46 by edelage           #+#    #+#             */
/*   Updated: 2022/10/17 15:31:06 by edelage          ###   ########lyon.fr   */
/*                                                                            */
/* ************************************************************************** */
#include <stdio.h>
#include <fcntl.h>
#include <stdlib.h>
#include <string.h>
#include <time.h>
#include "get_next_line.h"
#include "ld.h"
#ifndef NB_CALL_GET_NEXT_LINE
# define NB_CALL_GET_NEXT_LINE	50
#endif
#define SIZE	1500

int	compare_line(char *line_gnl, char *real_line)
{
	if (line_gnl == NULL && real_line == NULL)
		return (1);
	else if (line_gnl == NULL || real_line == NULL)
		return (0);
	else if (strcmp(line_gnl, real_line) == 0)
		return (1);
	return (0);
}

int	main(void)
{
	FILE	*file, *file1, *file2, *file3, *file4, *file5;
	int 	fd, fd1, fd2, fd3, fd4, fd5;
	int		random;
	char	*line_gnl;
	char	*real_line;

	srand(time(NULL));
	random = -1;
	/*==== Open file ====*/
	file = fopen("file/fd_bonus", "r");
	if (file == NULL)
		return (2);
	file1 = fopen("file/fd_bonus1", "r");
	if (file1 == NULL)
	{
		fclose(file);
		return (2);
	}
	file2 = fopen("file/fd_bonus2", "r");
	if (file2 == NULL)
	{
		fclose(file);
		fclose(file1);
		return (2);
	}
	file3 = fopen("file/fd_bonus3", "r");
	if (file3 == NULL)
	{
		fclose(file);
		fclose(file1);
		fclose(file2);
		return (2);
	}
	file4 = fopen("file/fd_bonus4", "r");
	if (file4 == NULL)
	{
		fclose(file);
		fclose(file1);
		fclose(file2);
		fclose(file3);
		return (2);
	}
	file5 = fopen("file/fd_bonus5", "r");
	if (file5 == NULL)
	{
		fclose(file);
		fclose(file1);
		fclose(file2);
		fclose(file3);
		fclose(file4);
		return (2);
	}
	fd = open("file/fd_bonus", O_RDONLY);
	if (fd == -1)
	{
		fclose(file);
		fclose(file1);
		fclose(file2);
		fclose(file3);
		fclose(file4);
		fclose(file5);
		return (2);
	}
	fd1 = open("file/fd_bonus1", O_RDONLY);
	if (fd1 == -1)
	{
		fclose(file);
		fclose(file1);
		fclose(file2);
		fclose(file3);
		fclose(file4);
		fclose(file5);
		close(fd);
		return (2);
	}
	fd2 = open("file/fd_bonus2", O_RDONLY);
	if (fd2 == -1)
	{
		fclose(file);
		fclose(file1);
		fclose(file2);
		fclose(file3);
		fclose(file4);
		fclose(file5);
		close(fd);
		close(fd1);
		return (2);
	}
	fd3 = open("file/fd_bonus3", O_RDONLY);
	if (fd3 == -1)
	{
		fclose(file);
		fclose(file1);
		fclose(file2);
		fclose(file3);
		fclose(file4);
		fclose(file5);
		close(fd);
		close(fd1);
		close(fd2);
		return (2);
	}
	fd4 = open("file/fd_bonus4", O_RDONLY);
	if (fd4 == -1)
	{
		fclose(file);
		fclose(file1);
		fclose(file2);
		fclose(file3);
		fclose(file4);
		fclose(file5);
		close(fd);
		close(fd1);
		close(fd2);
		close(fd3);
		return (2);
	}
	fd5 = open("file/fd_bonus5", O_RDONLY);
	if (fd5 == -1)
	{
		fclose(file);
		fclose(file1);
		fclose(file2);
		fclose(file3);
		fclose(file4);
		fclose(file5);
		close(fd);
		close(fd1);
		close(fd2);
		close(fd3);
		close(fd4);
		return (2);
	}
	/*==== Read file ====*/
	for (int i = 0; i < NB_CALL_GET_NEXT_LINE; i++)
	{
		random = rand() % 6;
		real_line = (char *) malloc(sizeof(char) * SIZE);
		if (real_line == NULL)
		{
			fclose(file);
			fclose(file1);
			fclose(file2);
			fclose(file3);
			fclose(file4);
			fclose(file5);
			close(fd);
			close(fd1);
			close(fd2);
			close(fd3);
			close(fd4);
			return (2);
		}
		bzero(real_line, sizeof(char) * SIZE);
		if (random == 0)
		{
			fgets(real_line, SIZE, file);
			if (strlen(real_line) == 0)
			{
				free(real_line);
				real_line = NULL;
			}
			line_gnl = get_next_line(fd);
		}
		else if (random == 1)
		{
			fgets(real_line, SIZE, file1);
			if (strlen(real_line) == 0)
			{
				free(real_line);
				real_line = NULL;
			}
			line_gnl = get_next_line(fd1);
		}
		else if (random == 2)
		{
			fgets(real_line, SIZE, file2);
			if (strlen(real_line) == 0)
			{
				free(real_line);
				real_line = NULL;
			}
			line_gnl = get_next_line(fd2);
		}
		else if (random == 3)
		{
			fgets(real_line, SIZE, file3);
			if (strlen(real_line) == 0)
			{
				free(real_line);
				real_line = NULL;
			}
			line_gnl = get_next_line(fd3);
		}
		else if (random == 4)
		{
			fgets(real_line, SIZE, file4);
			if (strlen(real_line) == 0)
			{
				free(real_line);
				real_line = NULL;
			}
			line_gnl = get_next_line(fd4);
		}
		else if (random == 5)
		{
			fgets(real_line, SIZE, file5);
			if (strlen(real_line) == 0)
			{
				free(real_line);
				real_line = NULL;
			}
			line_gnl = get_next_line(fd5);
		}
		if (compare_line(line_gnl, real_line) == 0)
		{
			if (line_gnl != NULL)
				free(line_gnl);
			if (real_line != NULL)
				free(real_line);
			if (have_leaks() == 1)
				// Return Fail with leaks
				return (3);
			// Return Fail
			return (1);
		}
		// Free
		if (line_gnl != NULL)
			free(line_gnl);
		if (real_line != NULL)
			free(real_line);

	}
	/*==== Close file ====*/
	fclose(file);
	fclose(file1);
	fclose(file2);
	fclose(file3);
	fclose(file4);
	fclose(file5);
	close(fd);
	close(fd1);
	close(fd2);
	close(fd3);
	close(fd4);
	close(fd5);
	if (have_leaks() == 1)
		return (4);
	return (0);
}
