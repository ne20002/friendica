{{*
  * Copyright (C) 2010-2024, the Friendica project
  * SPDX-FileCopyrightText: 2010-2024 the Friendica project
  *
  * SPDX-License-Identifier: AGPL-3.0-or-later
  *}}

<div class="mail-list-outside-wrapper">
	<div class="mail-list-sender">
		<a href="{{$from_url}}" title="{{$from_addr}}" class="mail-list-sender-url"><img class="mail-list-sender-photo{{$sparkle}}" src="{{$from_photo}}" height="80" width="80" alt="{{$from_name}}" title="{{$from_addr}}" /></a>
	</div>
	<div class="mail-list-detail">
		<div class="mail-list-sender-name">{{$from_name}}</div>
		<div class="mail-list-date">{{$date}}</div>
		<div class="mail-list-subject"><a href="message/{{$id}}" class="mail-list-link">{{$subject}}</a></div>
	<div class="mail-list-delete-wrapper" id="mail-list-delete-wrapper-{{$id}}">
		<a href="message/dropconv/{{$id}}" onclick="return confirmDelete();"  title="{{$delete}}" class="icon drophide mail-list-delete	delete-icon" onmouseover="imgbright(this);" onmouseout="imgdull(this);"></a>
	</div>
</div>
</div>
<div class="mail-list-delete-end"></div>

<div class="mail-list-outside-wrapper-end"></div>
