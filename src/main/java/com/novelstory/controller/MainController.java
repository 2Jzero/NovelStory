package com.novelstory.controller;

import java.util.ArrayList;
import java.util.HashSet;
import java.util.Random;
import java.util.Set;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.novelstory.model.EpisodeTO;
import com.novelstory.model.NovelListTO;
import com.novelstory.model.UserTO;
import com.novelstory.service.NovelService;
import com.novelstory.service.UserService;
import com.novelstory.service.EpisodeService;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@RestController
public class MainController {

	@Autowired
	private NovelService service;
	
	@Autowired
	private EpisodeService vService;	
	
	@Autowired
	private UserService uService;

	// Novel Story 메인 화면
	@RequestMapping("novelStory.do")
	public ModelAndView novelStory(@RequestParam(value= "category", required = false)  String category, HttpServletRequest request) {
		
		// 소설 리스트
		ArrayList<NovelListTO> categoryList = service.categoryList(category);
		
		EpisodeTO epTO = new EpisodeTO();
		
		String searchWord = request.getParameter("searchWord");

		// category가 null일 경우 전체 리스트 출력
		if(category == null) {
			
			categoryList = service.novelList();
		}
		
		// 검색했을 경우 해당 검색 관련 리스트 출력
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

		String userId = (String) session.getAttribute("logId");
		
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
	
	// 뷰페이지
	@RequestMapping("novelView.do")
	public ModelAndView novelView(@RequestParam("nvId") String nvId, HttpServletRequest request) {

		NovelListTO nvTO = new NovelListTO();

		nvTO = service.novelView(nvId);

		String nvwriter = nvTO.getNvwriter();

		// 해당 소설의 회차
		ArrayList<EpisodeTO> epList = vService.viewEpisode(nvId);

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
	
	// 마이 페이지
	@RequestMapping("novelMypage.do")
	public ModelAndView novelMypage(HttpSession session) {
		
		String userId = (String) session.getAttribute("logId");
		
		// 내가 구매한 소설의 리스트
		ArrayList<EpisodeTO> myList = vService.myList(userId);
		// 내가 구매한 소설의 정보
		ArrayList<NovelListTO> novelInfo = new ArrayList<>();
		
		// nvId 값, 중복 제거
		Set<String> nvIdSet = new HashSet<>();
		
		// 구매 컬럼의 값을 얻음
		for(EpisodeTO epTO : myList) {	

			String nvId = epTO.getNvId();
				
			// 중복된 것이 추가되면 false를 반환하여 true일 경우에만 반복문 진입
			if(nvIdSet.add(nvId)) {
				
				novelInfo.addAll(service.purchasedNovel(nvId));

			}
			
		}
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("main/novelMypage");
		modelAndView.addObject("novelInfo", novelInfo);
		return modelAndView;
	}
	
	@PostMapping("dailyGacha.do")
	public int dailyGacha(@RequestParam("sessionId") String userId, HttpServletResponse response, HttpSession session) {
		
		UserTO userInfo = uService.userInfo(userId);
		
		// 해당 유저의 포인트
		int userPoint = userInfo.getUserPoint();
		
		// 뽑기 후 결과 값을 저장할 포인트
		int newPoint = 0;
		
		int[] points = {100, 200, 300, 500};
		double[] probabilities = {0.5, 0.3, 0.15, 0.05};
		
		int returnPoint = 0;
		
		Random rand = new Random();
		double randomValue = rand.nextDouble(); // 0.0 ~ 1.0
		
		if(randomValue <= probabilities[0]) {
			// 현재 내 포인트에 당첨된 포인트를 더하여 합산
			newPoint = userPoint + points[0];
			// 당첨된 포인트를 알려주기 위한 반환값
			returnPoint = points[0];
		} else if(randomValue > probabilities[0] && randomValue <= probabilities[0] + probabilities[1]) {
			newPoint = userPoint + points[1];
			returnPoint = points[1];
		} else if(randomValue > probabilities[0] + probabilities[1] && randomValue <= probabilities[1] + probabilities[2]) {
			newPoint = userPoint + points[2];
			returnPoint = points[2];
		} else {
			newPoint = userPoint + points[3];
			returnPoint = points[3];
		};
		
		int flag = uService.myPoint(newPoint, userId);
		
		session.setAttribute("point", newPoint);
		
		Cookie cookie = new Cookie("isAlreadyGaCha-" + userId, userId);
		cookie.setMaxAge(60 * 60 * 24); // 기간 1일
		cookie.setPath("/"); // 쿠키 유효 경로 설정, 모두 적용하게 /
	    response.addCookie(cookie); // 클라이언트로 쿠키 전송

		
		return returnPoint;
	}

}
