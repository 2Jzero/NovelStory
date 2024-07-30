package com.novelstory.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.novelstory.model.EpisodeTO;
import com.novelstory.model.NovelListTO;
import com.novelstory.service.UserService;
import com.novelstory.service.EpisodeService;
import com.novelstory.service.NovelService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@RestController
public class EpisodeController {

	@Autowired
	private NovelService service;
	
	@Autowired
	private EpisodeService eService;
	
	@Autowired
	private UserService uService;
	
	// 소설의 n화 페이지
	@RequestMapping("viewEpisode.do")
	public ModelAndView viewEpisode(@RequestParam("nvId") String nvId, @RequestParam("episode") String EPISODE, 
			HttpServletRequest request, HttpSession session) {

		ModelAndView modelAndView = new ModelAndView();

		NovelListTO nvTO = service.novelView(nvId);
		
		EpisodeTO epTO = eService.specificEpisode(nvId, EPISODE);
		
		String isPurchased = epTO.getIS_PURCHASED();
		
		// 회차의 마지막화
		int epNumMax = eService.epNumMax(nvId);
		
		// X를 조건식에 사용하기 위함
    	Set<String> purchasedIdsSet = new HashSet<>(Arrays.asList(epTO.getIS_PURCHASED().split("/")));
		
		
		String userId = (String)session.getAttribute("logId");
		Integer myPoint = (Integer)session.getAttribute("point");

		
		// 유료 포인트 사용시 차감, 포은트 부족 시 대처 방법 기술, 무료보기일 경우는 제외하기
		if(!purchasedIdsSet.contains(userId) && !purchasedIdsSet.contains("무료")) {
			
			// 포인트가 최소단위인 100원보다 부족할 경우 결제 막기(마이너스 방지)
			if(myPoint < 100) {			
				// 결제 실패창으로 이동
			    modelAndView.setViewName("redirect:/purchaseFail");  
			    return modelAndView;
			} else {
				//100포인트 차감
				myPoint = myPoint - 100;

				// 소설을 구매한 아이디(세션)값을 입력 -> 구매내역 확인, 구매한 물품 소장으로 바꾸기 등 활용 가능
				isPurchased += "/"+userId;
				
				// 사용자 정보에 포인트 값 갱신
				int pointUpdate = uService.myPoint(myPoint, userId);
				
				// 구매 상태 소장으로 변경
				int isPurchasedUpdate = eService.isPurchased(isPurchased, nvId, EPISODE);
			}
										
			// 포인트 값 갱신
			session.setAttribute("point", myPoint);
		}
		
		modelAndView.setViewName("main/viewEpisode");
		modelAndView.addObject("nvTO", nvTO);
		modelAndView.addObject("epTO", epTO);
		modelAndView.addObject("purchasedIdsSet", purchasedIdsSet);
		modelAndView.addObject("epNumMax", epNumMax);
		return modelAndView;
	}
	
	// 이전화
	@RequestMapping("epBackward.do")
	Map<String, Object> epBackward(@RequestParam("nvId") String nvId, @RequestParam("epNum") int epNum) {
		
		// 이전화기 떄문에 -1 해주기
		int EP_NUM = epNum - 1;
		
		// -1한 epNum을 통하여 episode값을 가져옴( ex > 2화면 1화의 id값)
        Map<String, Object> epInfo = eService.epMove(nvId, EP_NUM);
				
		return epInfo;
	}
	
	// 다음화에 필요한 EPISODE값 반환하는 메서드
	@RequestMapping("epForward.do")
	Map<String, Object> epForward(@RequestParam("nvId") String nvId, @RequestParam("epNum") int epNum) {
		
		// 이전화기 떄문에 -1 해주기
		int EP_NUM = epNum + 1;
		
		// +1한 epNum을 통하여 episode,EP_NUM,IS_PURCHASED값을 가져옴( ex > 2화면 3화의 id값)
        Map<String, Object> epInfo = eService.epMove(nvId, EP_NUM);
        
		return epInfo;
	}
	
	// 소설 구매 실패 페이지
	@RequestMapping("/purchaseFail")
	public ModelAndView purchaseFail() {


		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("payment/purchaseFail");
		return modelAndView;
	}

}
