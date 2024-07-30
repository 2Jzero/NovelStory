package com.novelstory.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.novelstory.mapper.NovelListMapperInter;
import com.novelstory.model.NovelListTO;

@Service
public class NovelService {
	
	@Autowired
	private NovelListMapperInter novel_mapper;
	
	// 전체 소설 리스트
	public ArrayList<NovelListTO> novelList() {
		
		return novel_mapper.novelList();
	}

	// 장르별 소설 리스트
	public ArrayList<NovelListTO> categoryList(String category) {		
		
		return novel_mapper.categoryList(category);
	}
	
	// 검색한 소설 리스트
	public ArrayList<NovelListTO> searchNovelList(String searchWord) {
				
		return novel_mapper.searchNovelList(searchWord);
	}
	
	// 선택한 소설의 뷰 리스트
	public NovelListTO novelView(String nvId) {
		
		return novel_mapper.novelView(nvId);
	}
	
	// 작가의 다른 작품 리스트
	public ArrayList<NovelListTO> ohterNovel(String nvwriter) {
		
		return novel_mapper.ohterNovel(nvwriter);
	}

	// 구입한 회차의 소설 리스트
	public ArrayList<NovelListTO> purchasedNovel(String nvId) {

		return novel_mapper.purchasedNovel(nvId);
	}
	
}
