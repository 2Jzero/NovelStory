package com.novelstory.controller;

import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.ModelAndView;

import com.novelstory.service.Nservice;

import jakarta.annotation.Resource;
import jakarta.servlet.http.HttpServletRequest;

@RestController
public class CrawlingController {
	
	@Resource(name = "NovelCrawling")
	private Nservice novelCrawling;
	
	/* 소설 리스트 크롤링 정보*/
	@RequestMapping("/novelCwling.do")
	public ModelAndView novelCrawling(HttpServletRequest request) throws Exception {
		
		int res = novelCrawling.getNovelInfoFromWEB();
		
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("novelCwling");
		modelAndView.addObject("res", String.valueOf(res));
		
		
		return modelAndView;
	}
}
