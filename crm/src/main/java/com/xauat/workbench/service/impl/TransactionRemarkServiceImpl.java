package com.xauat.workbench.service.impl;

import com.xauat.workbench.mapper.TransactionRemarkMapper;
import com.xauat.workbench.pojo.TransactionRemark;
import com.xauat.workbench.service.TransactionRemarkService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
public class TransactionRemarkServiceImpl implements TransactionRemarkService {
    @Autowired
    private TransactionRemarkMapper transactionRemarkMapper;

    @Override
    public List<TransactionRemark> queryTransactionRemarkByTransactionId(String transactionId) {
        return transactionRemarkMapper.selectTransactionRemarkByTransactionId(transactionId);
    }

    @Override
    public int saveCreateTransactionRemark(TransactionRemark transactionRemark) {
        return transactionRemarkMapper.insertTransactionRemark(transactionRemark);
    }

    @Override
    public int deleteTransactionRemarkById(String id) {
        return transactionRemarkMapper.deleteTransactionRemarkById(id);
    }

    @Override
    public int saveEditTransactionRemark(TransactionRemark transactionRemark) {
        return transactionRemarkMapper.updateTransactionRemark(transactionRemark);
    }
}
