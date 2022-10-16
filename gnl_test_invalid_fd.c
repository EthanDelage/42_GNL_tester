/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   gnl_test_invalid_fd.c                              :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: edelage <edelage@student.42lyon.fr>        +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2022/10/16 17:00:47 by edelage           #+#    #+#             */
/*   Updated: 2022/10/16 18:07:57 by edelage          ###   ########lyon.fr   */
/*                                                                            */
/* ************************************************************************** */
#include <stdlib.h>
#include "get_next_line.h"
#include "ld.h"
#ifndef NB_CALL_GET_NEXT_LINE
# define NB_CALL_GET_NEXT_LINE	1
#endif

int	main(void)
{
	int		fd;
	char	*line_gnl;

	fd = -1;
	for (int i = 0; i < NB_CALL_GET_NEXT_LINE; i++)
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
	if (have_leaks() == 1)
		return (4);
	return (0);
}
