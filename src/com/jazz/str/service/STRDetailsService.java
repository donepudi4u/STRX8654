/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.jazz.str.service;

import com.jazz.str.vo.STRDetailsVO;
import java.util.List;
import java.util.Map;

/**
 *
 * @author kudaraa
 */
public interface STRDetailsService {
    
    public List<String> getUniqueFiledValues(String fieldName)throws Exception;
    public List<STRDetailsVO> getSTRDetailsForField(String fieldName ,String fieldVal);
    public List<STRDetailsVO> getSTRDetailsForFields(Map<String,String> fieldsMap);
    public List<String> getAreaNamesByFieldName(String fieldName, String fieldVal);
    public List<String> getEngineerNamesByFieldName(String fieldName, String fieldVal);
    
}
