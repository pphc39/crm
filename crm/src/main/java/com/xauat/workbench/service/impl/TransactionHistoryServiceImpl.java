package com.xauat.workbench.service.impl;

import com.xauat.workbench.mapper.TransactionHistoryMapper;
import com.xauat.workbench.pojo.TransactionHistory;
import com.xauat.workbench.service.TransactionHistoryService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TransactionHistoryServiceImpl implements TransactionHistoryService {
    @Autowired
    private TransactionHistoryMapper transactionHistoryMapper;

    @Override
    public List<TransactionHistory> queryTransactionHistoryByTransactionId(String transactionId) {
        return transactionHistoryMapper.selectTransactionHistoryByTransactionId(transactionId);
    }
}
