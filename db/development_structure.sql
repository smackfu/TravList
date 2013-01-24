CREATE TABLE `continents` (
  `id` char(2) NOT NULL default '',
  `name` varchar(255) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `countries` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `isocode` char(2) NOT NULL default '',
  `fipscode` char(2) NOT NULL default '',
  `continent_id` char(2) NOT NULL default '',
  `has_flag` tinyint(1) NOT NULL default '1',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `daynotes` (
  `id` int(11) NOT NULL auto_increment,
  `userplace_id` int(11) NOT NULL default '0',
  `date` date NOT NULL default '0000-00-00',
  `comment` text NOT NULL,
  `private` tinyint(1) NOT NULL default '0',
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `issues` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL default '0',
  `url` varchar(255) NOT NULL default '',
  `description` text NOT NULL,
  `severity` int(11) NOT NULL default '0',
  `response` text NOT NULL,
  `closed` tinyint(1) NOT NULL default '0',
  `created_at` datetime default NULL,
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `places` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `localname` varchar(255) NOT NULL default '',
  `country_id` int(11) NOT NULL default '0',
  `lat` float NOT NULL default '0',
  `long` float NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `trips` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(255) NOT NULL default '',
  `comment` text NOT NULL,
  `start` date default '0000-00-00',
  `who_with` varchar(255) NOT NULL default '',
  `fake` tinyint(1) NOT NULL default '0',
  `user_id` int(11) NOT NULL default '0',
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `userpersists` (
  `id` int(11) NOT NULL auto_increment,
  `cookie` varchar(100) NOT NULL default '',
  `user_id` int(11) NOT NULL default '0',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `userplaces` (
  `id` int(11) NOT NULL auto_increment,
  `place_id` int(11) NOT NULL default '0',
  `trip_id` int(11) NOT NULL default '0',
  `rating` int(11) NOT NULL default '0',
  `comment` text NOT NULL,
  `private` tinyint(1) NOT NULL default '0',
  `review` text NOT NULL,
  `dayorder` int(11) NOT NULL default '0',
  `major` tinyint(1) NOT NULL default '0',
  `start_date` date default '0000-00-00',
  `end_date` date default '0000-00-00',
  `photo_url` varchar(255) NOT NULL default '',
  `flickr_photo` varchar(64) NOT NULL default '',
  `who_with` varchar(255) NOT NULL default '',
  `nomap` tinyint(1) NOT NULL default '0',
  `updated_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `userprefs` (
  `id` int(11) NOT NULL auto_increment,
  `user_id` int(11) NOT NULL default '0',
  `wishlist_trip_id` int(11) NOT NULL default '0',
  `notrip_trip_id` int(11) NOT NULL default '0',
  `flickr_name` varchar(255) NOT NULL default '',
  `email` varchar(128) NOT NULL default '',
  `url` varchar(128) NOT NULL default '',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

CREATE TABLE `users` (
  `id` int(11) NOT NULL auto_increment,
  `login` varchar(60) default NULL,
  `password` varchar(40) default NULL,
  `created_at` datetime default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

