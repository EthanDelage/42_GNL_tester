/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   gnl_test_mandatory.c                               :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: edelage <edelage@student.42lyon.fr>        +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/10/14 22:15:55 by edelage           #+#    #+#             */
/*   Updated: 2022/10/14 23:49:06 by edelage          ###   ########lyon.fr   */
/*                                                                            */
/* ************************************************************************** */
#include <stdio.h>
#include <fcntl.h>
#include <unistd.h>
#include <stdlib.h>
#include <string.h>
#include "get_next_line.h"
#ifndef NB_CALL_GET_NEXT_LINE
# define NB_CALL_GET_NEXT_LINE	50
#endif
#define	SIZE	1500

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

int	main(int argc, char **argv)
{
	FILE	*file;
	int		fd;
	char	*line_gnl;
	char	*real_line;

	/*==== Open file ====*/
	if (argc != 2)
	{
		// Return Error
		return (2);
	}
	file = fopen(argv[1], "r");
	if (file == NULL)
	{
		// Return Error
		return (2);
	}
	fd = open(argv[1], O_RDONLY);
	if (fd == -1)
	{
		fclose(file);
		// Return Error
		return (2);
	}
	/*==== Read file ====*/
	for (int i = 0; i < NB_CALL_GET_NEXT_LINE; i++)
	{
		// Read with fgets
		real_line = (char *) malloc(sizeof(char) * SIZE);
		if (real_line == NULL)
		{
			fclose(file);
			close(fd);
			// Return Error
			return (2);
		}
		bzero(real_line, sizeof(char) * SIZE);
		fgets(real_line, SIZE, file);
		if (strlen(real_line) == 0)
		{
			free(real_line);
			real_line = NULL;
		}
		// Read with get_next_line
		line_gnl = get_next_line(fd);
		// Compare line
		if (compare_line(line_gnl, real_line) == 0)
		{
			if (line_gnl != NULL)
				free(line_gnl);
			if (real_line != NULL)
				free(real_line);
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
	close(fd);
	// Return Success
	return (0);
}
