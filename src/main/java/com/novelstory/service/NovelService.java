package com.novelstory.service;

import java.util.ArrayList;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.novelstory.mapper.NovelListMapperInter;
import com.novelstory.model.EpisodeTO;
import com.novelstory.model.NovelListTO;

@Service
public class NovelService {
	
	@Autowired
	private NovelListMapperInter mapper;
	
	// 전체 소설 리스트
	public ArrayList<NovelListTO> novelList() {
		
		return mapper.novelList();
	}

	// 장르별 소설 리스트
	public ArrayList<NovelListTO> categoryList(String category) {		
		
		return mapper.categoryList(category);
	}
	
	// 검색한 소설 리스트
	public ArrayList<NovelListTO> searchNovelList(String searchWord) {
				
		return mapper.searchNovelList(searchWord);
	}
	
	// 선택한 소설의 뷰 리스트
	public NovelListTO novelView(String nvId) {
		
		return mapper.novelView(nvId);
	}
	
	// 특정 소설의 회차목록
	public ArrayList<EpisodeTO> viewEpisode(String nvId) {
		
		return mapper.viewEpisode(nvId);
	}
	
	// 특정 소설의 특정 회차
	public EpisodeTO specificEpisode(String nvId, String EPISODE) {
		
		return mapper.specificEpisode(nvId, EPISODE);
	}
	
	// 구매 상태 변경 여부 로직
	public int isPurchased(String isPurchased, String nvId, String EPISODE) {
		int isPurchasedUpdate = 1;
		
		int result = mapper.isPurchased(isPurchased, nvId, EPISODE);
		
		if(result == 1) {
			isPurchasedUpdate = 0;
		}
		
		return isPurchasedUpdate;
	}
	
//	public int insertData(EpisodeTO epTO) {
//		
//		int flag = 1;
//		
//		int result = mapper.insertData(epTO);
//		
//		if(result == 1) {
//			flag = 0;
//		}
//		
//		return flag;
//	}
}
