package com.novelstory.service;



import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import com.novelstory.mapper.UserMapperInter;
import com.novelstory.model.UserTO;

import kotlinx.serialization.json.JsonObject;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.exception.NurigoMessageNotReceivedException;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.service.DefaultMessageService;

@Service
public class UserService {
	
	@Autowired
	private UserMapperInter mapper;
	
	// 회원가입
	public int userSign(UserTO to) {
		
		int flag = 1;
		
		// DB 저장 전 BCrypt를 사용해서 비밀번호 암호화 시키고 저장
		BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
		String encodeUserPassword = encoder.encode(to.getPassword());
		to.setPassword(encodeUserPassword);
		
		int result = mapper.userSign(to);
		
		if(result == 1) {
			flag = 0;
		}
				
		return flag;
	}
	
	// 로그인
	public int userLogin(String id, String pw) {
		
		int loginFlag = 1;
		
		UserTO login = mapper.userInfo(id);
				
		if(login != null) {
			BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
			String dbPassword = login.getPassword(); // db에 저장되어 있는 암호화 비밀번호
						
			if(encoder.matches(pw, dbPassword)) {
				
				// 비밀번호 일치
				loginFlag = 0;
				
				return loginFlag;
			}
		}		
		return loginFlag;	
	}
	
	// 로그인한 유저의 정보
	public UserTO userInfo(String id) {
		
		return mapper.userInfo(id);
	}
	
	
	// coolsms 휴대폰 인증
	public void certifiedPhoneNumber(String phone, String code) {
				
		DefaultMessageService messageService =  NurigoApp.INSTANCE.initialize("NCSJLVZFJYGG0XAG", "5IMNZ6GKNMLHPEPRFE7VXJGA0T9RDJYQ", "https://api.coolsms.co.kr");

		Message coolsms = new Message(); 
		
		coolsms.setTo(phone);
		coolsms.setFrom("01094494077");
		coolsms.setText("NovelStory 본인확인 인증번호는 " + "[" + code + "]" + "입니다.");
        
        
		try {
			  messageService.send(coolsms);
			} catch (NurigoMessageNotReceivedException exception) {
			  // 발송에 실패한 메시지 목록을 확인할 수 있습니다
			  System.out.println(exception.getFailedMessageList());
			  System.out.println(exception.getMessage());
			} catch (Exception exception) {
			  System.out.println(exception.getMessage());
			}
        
        
	}
	
	// 결제 성공 시 결제 값만큼 포인트 증가
	public int myPoint(int userPoint, String userId) {
		
		int pointUpdate = 1;
		int result = mapper.myPoint(userPoint, userId);

		if (result == 1) {
			pointUpdate = 0;
		}

		return pointUpdate;
	}
	
}
