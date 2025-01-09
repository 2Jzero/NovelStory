package com.novelstory.controller;

import java.util.ArrayList;
import java.util.Map;
import java.util.Random;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.novelstory.model.UserTO;
import com.novelstory.service.KakaoService;
import com.novelstory.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@RestController
public class UserController {

	private static final UserTO UserTO = null;
	@Autowired
	private UserService service;
	
	@Autowired
	private KakaoService kService;

	// 로그인
	@RequestMapping("novelStoryLogin.do")
	public ModelAndView userLogin() {
		
		
		ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("redirect:/novelStory.do"); // novelStory.do로 리다이렉트
		
		return modelAndView;
	}
	
	// 로그인 id, pw 체크용
	@RequestMapping("loginCheck.do")
	public int loginCheck(@RequestParam String id, @RequestParam String pw, HttpServletRequest request) {
		
		// 세션을 만들기 위해 로그인한 정보를 가져오기
		UserTO loginTO = service.userInfo(id);
				
		int loginFlag = service.userLogin(id, pw);
		
		if(loginFlag == 0) {
			HttpSession session = request.getSession();
			
			session.setAttribute("logId", loginTO.getUserId());
			session.setAttribute("birthDay", loginTO.getUserBirth());
			session.setAttribute("phone", loginTO.getUserPhone());
			session.setAttribute("point", loginTO.getUserPoint());
			session.setMaxInactiveInterval(60 * 60);

		}
		
		return loginFlag;
	}
	
	
	// 회원가입
	@RequestMapping("novelStorySign.do")
	public ModelAndView userSign(HttpServletRequest request) {
		
		UserTO signTO = new UserTO();
		
		// 회원가입 시 입력한 년, 월, 일 합쳐서 변수에 저장
		String year = request.getParameter("birth-year");
		String month = request.getParameter("birth-month");
		String day = request.getParameter("birth-day");
				
		String birthday = year + month + day;
				
		signTO.setUserId(request.getParameter("signId"));
		signTO.setPassword(request.getParameter("signPw"));
		signTO.setUserBirth(birthday);
		signTO.setUserPhone(request.getParameter("signPhone"));

		int flag = service.userSign(signTO);
				
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("login/signOk");
		modelAndView.addObject("flag", flag);
		
		return modelAndView;
	}
	
	// 핸드폰 인증번호 코드 보내기
	@GetMapping("/check/sendSMS")
	public String sendSMS(String phone) {
		
		
		Random rand = new Random();
		String code = "";
		
		for(int i = 0; i < 4; i++) {
			String ran = Integer.toString(rand.nextInt(10));
			code += ran;
		}
				
		service.certifiedPhoneNumber(phone, code);
		
		return code;
		
	}
	
	
	// 카카오 로그인
	@GetMapping("/kakao-login")
	public ModelAndView kakaoLogin(@RequestParam String code, HttpServletRequest request) {
		//String accessToken =
		
		String accessToken = kService.getAccessToken(code);
		
		// accessToken을 통해 얻은 유저 정보
		Map<String, Object> userInfo = kService.getKakaoUserInfo(accessToken);
		
		// 회원 카카오 id
		String kakaoId = String.valueOf(userInfo.get("id")) + "(카카오)";		
		
		// 카카오 로그인 정보를 넣을 UserTO
		UserTO to = new UserTO();
		
		//이 부분을 막아야한다.
		to.setUserId(kakaoId);
		to.setPassword("Kakao");
		to.setUserBirth("00000000");
		to.setUserPhone("00000000000");
		to.setUserPoint(0);
		
		int flag = service.kakaoUserSign(to);
		
		
		if(flag == 0) {
		HttpSession session = request.getSession();
		
		UserTO kakaoUser = service.userInfo(kakaoId);
		
		session.setAttribute("logId", kakaoUser.getUserId());
		session.setAttribute("point", kakaoUser.getUserPoint());
		session.setAttribute("accessToken", accessToken);
		session.setMaxInactiveInterval(60 * 60);
				
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("login/loginOk");
		modelAndView.addObject("flag", flag);
		
		return modelAndView;
	}
	
	
	// 로그아웃
	@RequestMapping("/logout.do")
	public ModelAndView userLogout(HttpServletRequest request) {
		
		HttpSession session = request.getSession();
		
		String userId = (String) session.getAttribute("logId");
		String accessToken = (String) session.getAttribute("accessToken");
		
		// 로그아웃 메서드 호출 변수
		boolean flag = false;
		
		if(userId.contains("카카오")) {
			flag = kService.logout(accessToken);
		}
				
		session.invalidate();
		
		
		ModelAndView modelAndView = new ModelAndView();
	    modelAndView.setViewName("redirect:/novelStory.do"); // novelStory.do로 리다이렉트

		return modelAndView;
		
	}
	
	

}
