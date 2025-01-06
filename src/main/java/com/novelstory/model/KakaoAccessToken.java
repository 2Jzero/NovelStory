package com.novelstory.model;

import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class KakaoAccessToken {
    private String access_token;  // access_token을 담을 변수
    private String refresh_token; // refresh_token을 담을 변수
    private int expires_in;       // 토큰의 만료 시간
    private String scope;         // 요청한 scope
}
