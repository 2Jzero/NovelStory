package com.novelstory.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.HashMap;
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
	@RequestMapping("novelStory.do")
	public ModelAndView novelStory(@RequestParam(value= "category", required = false)  String category, HttpServletRequest request) {
		
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
//						epTO.setIS_PURCHASED("");
//					}
//					
//					int flag = service.insertData(epTO);
//				}
//			}
//		}
				
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("main/novelStory");
		modelAndView.addObject("categoryList", categoryList);
		return modelAndView;
	}
	
	@RequestMapping("novelView.do")
	public ModelAndView novelView(@RequestParam("nvId") String nvId, HttpServletRequest request) {
		
		NovelListTO nvTO = new NovelListTO();
		
		nvTO = service.novelView(nvId);
		
		String nvwriter = nvTO.getNvwriter();
		
		ArrayList<EpisodeTO> epList = service.viewEpisode(nvId);
		
		// 작가의 다른 작품
		ArrayList<NovelListTO> otherList = new ArrayList<>();
		
		// 작가의 다른 작품
		otherList = service.ohterNovel(nvwriter);

		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("main/novelView");
		modelAndView.addObject("nvTO", nvTO);
		modelAndView.addObject("epList", epList);
		modelAndView.addObject("otherList", otherList);
		return modelAndView;
	}
	
	@RequestMapping("viewEpisode.do")
	public ModelAndView viewEpisode(@RequestParam("nvId") String nvId, @RequestParam("episode") String EPISODE, 
			HttpServletRequest request, HttpSession session) {

		ModelAndView modelAndView = new ModelAndView();

		NovelListTO nvTO = service.novelView(nvId);
		
		EpisodeTO epTO = service.specificEpisode(nvId, EPISODE);
		
		String isPurchased = epTO.getIS_PURCHASED();
		
		// 회차의 마지막화
		int epNumMax = service.epNumMax(nvId);
		
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
				int isPurchasedUpdate = service.isPurchased(isPurchased, nvId, EPISODE);
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
        Map<String, Object> epInfo = service.epMove(nvId, EP_NUM);
				
		return epInfo;
	}
	
	// 다음화에 필요한 EPISODE값 반환하는 메서드
	@RequestMapping("epForward.do")
	Map<String, Object> epForward(@RequestParam("nvId") String nvId, @RequestParam("epNum") int epNum) {
		
		// 이전화기 떄문에 -1 해주기
		int EP_NUM = epNum + 1;
		
		// +1한 epNum을 통하여 episode,EP_NUM,IS_PURCHASED값을 가져옴( ex > 2화면 3화의 id값)
        Map<String, Object> epInfo = service.epMove(nvId, EP_NUM);
        
		return epInfo;
	}
	
	// 소설 구매 실패 페이지
	@RequestMapping("/purchaseFail")
	public ModelAndView purchaseFail() {


		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("payment/purchaseFail");
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
		modelAndView.setViewName("payment/paySuccess");
		modelAndView.addObject("amount", amount);
		return modelAndView;
	}

	// 결제 실패 시
	@RequestMapping("/fail")
	public ModelAndView paymentFail() {


		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("payment/payFail");
		return modelAndView;
	}

}
