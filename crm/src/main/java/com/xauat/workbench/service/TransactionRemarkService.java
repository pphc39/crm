package com.xauat.workbench.service;

import com.xauat.workbench.pojo.TransactionRemark;

import java.util.List;

public interface TransactionRemarkService {
    List<TransactionRemark> queryTransactionRemarkByTransactionId(String transactionId);

    int saveCreateTransactionRemark(TransactionRemark transactionRemark);

    int deleteTransactionRemarkById(String id);

    int saveEditTransactionRemark(TransactionRemark transactionRemark);
}
