package com.novelstory.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class UserTO {
	private int userNum;
	private String userId;
	private String password;
	private String userBirth;
	private String userPhone;
	private int userPoint;
}
