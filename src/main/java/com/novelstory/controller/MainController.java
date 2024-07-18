package com.novelstory.controller;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.novelstory.model.EpisodeTO;
import com.novelstory.model.NovelListTO;
import com.novelstory.model.UserTO;
import com.novelstory.service.NovelService;
import com.novelstory.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@RestController
public class MainController {

	@Autowired
	private NovelService service;
	
	@Autowired
	private UserService uService;

	// Novel Story 메인 화면
	@RequestMapping("main.do")
	public ModelAndView main(@RequestParam(value= "category", required = false)  String category, HttpServletRequest request) {
		
		ArrayList<NovelListTO> novelList = service.novelList();
						
		ArrayList<NovelListTO> categoryList = service.categoryList(category);
		
		EpisodeTO epTO = new EpisodeTO();
		
		String searchWord = request.getParameter("searchWord");

		if(category == null) {
			
			categoryList = service.novelList();
		}
		
		if(searchWord != null) {
			
			categoryList = service.searchNovelList(searchWord);
		}
		
//		//더미 데이터 넣는 식		
//		if(request.getParameter("isData") != null) {
//			for(NovelListTO nvTO : novelList) {
//				for(int m = 1; m <= 5; m++) {
//										
//					epTO.setNvId(nvTO.getNvId());
//					epTO.setEP_NUM(m);
//					epTO.setEP_TITLE(m + "화");
//					epTO.setEP_CONTENT(nvTO.getNvtitle() + " " + m + "화입니다.");
//					epTO.setIS_PURCHASED("무료"); 
//					if(m > 3) {
//						epTO.setIS_PURCHASED("X");
//					}
//					
//					int flag = service.insertData(epTO);
//				}
//			}
//		}
				
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("main/main");
		modelAndView.addObject("categoryList", categoryList);
		return modelAndView;
	}
	
	@RequestMapping("novelView.do")
	public ModelAndView novelView(@RequestParam("nvId") String nvId, HttpServletRequest request) {
		
		NovelListTO nvTO = new NovelListTO();
		
		nvTO = service.novelView(nvId);
		
		ArrayList<EpisodeTO> epList = service.viewEpisode(nvId);
		
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("main/novelView");
		modelAndView.addObject("nvTO", nvTO);
		modelAndView.addObject("epList", epList);
		return modelAndView;
	}
	
	@RequestMapping("viewEpisode.do")
	public ModelAndView viewEpisode(@RequestParam("nvId") String nvId, @RequestParam("episode") String EPISODE, HttpServletRequest request, HttpSession session) {
		
		NovelListTO nvTO = service.novelView(nvId);
		
		EpisodeTO epTO = service.specificEpisode(nvId, EPISODE);
		
		String isPurchased = epTO.getIS_PURCHASED();
		
		
		String userId = (String)session.getAttribute("logId");
		Integer myPoint = (Integer)session.getAttribute("point");

		
		// 유료 포인트 사용시 차감, 포은트 부족 시 대처 방법 기술
		if(isPurchased.equals("X")) {
			// 100포인트 차감
			myPoint = myPoint - 100;
			
			// 구매한 소설의 구매상태를 소장으로 바꿈
			isPurchased = "소장";
			
			// 사용자 정보에 포인트 값 갱신
			int pointUpdate = uService.myPoint(myPoint, userId);
			
			// 구매 상태 소장으로 변경
			int isPurchasedUpdate = service.isPurchased(isPurchased, nvId, EPISODE);
			
			// 포인트 값 갱신
			session.setAttribute("point", myPoint);
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("main/viewEpisode");
		modelAndView.addObject("nvTO", nvTO);
		modelAndView.addObject("epTO", epTO);
		return modelAndView;
	}

	// Novel Story 코엔 결제창 화면
	@RequestMapping("novelstorypayments.do")
	public ModelAndView payments() {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("payment/payments");
		return modelAndView;
	}

	// 결제 성공 시
	@RequestMapping("/success")
	public ModelAndView paymentSuccess(@RequestParam("amount") int amount, HttpSession session) {

		String userId = (String)session.getAttribute("logId");
		
		UserTO userTO = uService.userInfo(userId);
		
		int myPoint = userTO.getUserPoint();
		
		System.out.print("결제 성공입니다!");
		System.out.print("myPoint : " + myPoint);
		System.out.print("Amount : " + amount);
		
		myPoint += amount;
		
		int flag = uService.myPoint(myPoint, userId);
		
		session.setAttribute("point", myPoint);

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("payment/success");
		modelAndView.addObject("amount", amount);
		return modelAndView;
	}

	// 결제 실패 시
	@RequestMapping("/fail")
	public ModelAndView paymentFail() {

		System.out.print("결제 실패입니다!");

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("payment/fail");
		return modelAndView;
	}

}
