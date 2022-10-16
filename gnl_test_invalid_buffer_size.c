/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   gnl_test_invalid_buffer_size.c                     :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: edelage <edelage@student.42lyon.fr>        +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/10/16 18:06:57 by edelage           #+#    #+#             */
/*   Updated: 2022/10/16 18:43:20 by edelage          ###   ########lyon.fr   */
/*                                                                            */
/* ************************************************************************** */
#include <stdlib.h>
#include <fcntl.h>
#include <unistd.h>
#ifndef BUFFER_SIZE
# define BUFFER_SIZE	0
#endif
#include "get_next_line.h"
#include "ld.h"

int	main(void)
{
	int		fd;
	char	*line_gnl;

	if (BUFFER_SIZE > 0)
		return (0);
	fd = open("file/fd_Simple_Input", O_RDONLY);
	if (fd == -1)
		return (2);
	for (int i = 0; i < 10; i++)
	{
		line_gnl = get_next_line(fd);
		if (line_gnl != NULL)
		{
			free(line_gnl);
			if (have_leaks() == 1)
				return (3);
			return (1);
		}
	}
	close(fd);
	if (have_leaks() == 1)
		return (4);
	return (0);
}
