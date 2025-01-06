package com.novelstory.mapper;


import org.apache.ibatis.annotations.Mapper;
import com.novelstory.model.UserTO;

@Mapper
public interface UserMapperInter {

	// 회원가입
	int userSign(UserTO to);
    
	// 유저 정보 확인 및 로그인 등에 사용
	UserTO userInfo(String id);

	// 코인 결제, 소설 구매 후 나의 포인트
	int myPoint(int userPoint, String userId);

}
