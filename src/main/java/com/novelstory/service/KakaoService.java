package com.novelstory.service;



import java.util.HashMap;
import java.util.Map;

import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import com.novelstory.model.KakaoAccessToken;
import com.novelstory.model.KakaoUserInfo;

@Service
public class KakaoService {
	
	public String getAccessToken(String code) {
		
		RestTemplate restTemplate = new RestTemplate();
		
	    String reqUrl = "https://kauth.kakao.com/oauth/token";
	    	    
        // 요청 파라미터 설정
        MultiValueMap<String, String> params = new LinkedMultiValueMap<>();
        params.add("grant_type", "authorization_code");
        params.add("client_id", "dda5b7829285c1bc14a5df7faa52c6df");
        params.add("redirect_uri", "http://localhost:8080/novelstory/kakao-login");
        params.add("code", code);
        
        // POST 요청 (request body에 파라미터를 담아 전송)
        ResponseEntity<KakaoAccessToken> response = restTemplate.postForEntity(reqUrl, params, KakaoAccessToken.class);
        
        // 자동으로 JSON을 KakaoAccessToken 객체로 변환
        KakaoAccessToken accessToken = response.getBody();
        return accessToken.getAccess_token();         
        
	}
	
    public Map<String, Object> getKakaoUserInfo(String accessToken) {

    	RestTemplate restTemplate = new RestTemplate();

    	String reqUrl = "https://kapi.kakao.com/v2/user/me";
    	
        // 요청 헤더에 Authorization: Bearer {access_token} 추가
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);

        // HttpEntity 생성
        HttpEntity<Void> entity = new HttpEntity<>(headers);

        // GET 요청
        ResponseEntity<Map> response = restTemplate.exchange(
        	reqUrl,
            HttpMethod.GET,
            entity,
            Map.class
        );

        // 응답 처리
        Map<String, Object> userInfo = response.getBody();
        
        return userInfo; // 카카오 사용자 정보 반환
    }
    
    
    public Boolean logout(String accessToken) {

    	RestTemplate restTemplate = new RestTemplate();

    	String reqUrl = "https://kapi.kakao.com/v1/user/logout";
    	
        // 요청 헤더에 Authorization: Bearer {access_token} 추가
        HttpHeaders headers = new HttpHeaders();
        headers.add("Authorization", "Bearer " + accessToken);
        
        HttpEntity<String> entity = new HttpEntity<>(headers);

        // POST 요청
        ResponseEntity<String> response = restTemplate.exchange(reqUrl, HttpMethod.POST, entity, String.class);
        
        // 응답 코드 확인
        if (response.getStatusCode().is2xxSuccessful()) {
            return true;
        } else {
            return false;
        }
        
    }
	
}
