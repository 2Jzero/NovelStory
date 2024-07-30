package com.novelstory.service;

import java.util.ArrayList;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.novelstory.mapper.EpisodeMapperInter;
import com.novelstory.model.EpisodeTO;

@Service
public class EpisodeService {
	

	@Autowired
	private EpisodeMapperInter ep_mapper;
	
	// 특정 소설의 회차목록
	public ArrayList<EpisodeTO> viewEpisode(String nvId) {
		
		return ep_mapper.viewEpisode(nvId);
	}
	
	// 다음화에 필요한 EPISODE값 반환
	public Map<String, Object> epMove(String nvId, int EP_NUM) {
		
		return ep_mapper.epMove(nvId, EP_NUM);
	}
	
	// 소설의 마지막화
	public int epNumMax(String nvId) {
		
		return ep_mapper.epNumMax(nvId);
	}
	
	// 특정 소설의 특정 회차
	public EpisodeTO specificEpisode(String nvId, String EPISODE) {
		
		return ep_mapper.specificEpisode(nvId, EPISODE);
	}
	
	// 구매 상태 변경 여부 로직
	public int isPurchased(String isPurchased, String nvId, String EPISODE) {
		int isPurchasedUpdate = 1;
		
		int result = ep_mapper.isPurchased(isPurchased, nvId, EPISODE);
		
		if(result == 1) {
			isPurchasedUpdate = 0;
		}
		
		return isPurchasedUpdate;
	}
	
	// 나의 소장한 소설 리스트
	public ArrayList<EpisodeTO> myList(String userId) {
		
		return ep_mapper.myList(userId);
	}

//	// 더미 데이터 서비스
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
