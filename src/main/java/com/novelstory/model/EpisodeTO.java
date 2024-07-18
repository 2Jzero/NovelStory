package com.novelstory.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class EpisodeTO {
	private String EPISODE;
	private String nvId;  // 외래키
	private int EP_NUM;
	private String EP_TITLE;
	private String EP_CONTENT;
	private String CREATE_DAY;
	private String IS_PURCHASED;
	private String EP_HIT;
	
}
