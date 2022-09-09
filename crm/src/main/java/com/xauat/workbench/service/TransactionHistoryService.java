package com.xauat.workbench.service;

import com.xauat.workbench.pojo.TransactionHistory;

import java.util.List;

public interface TransactionHistoryService {
    List<TransactionHistory> queryTransactionHistoryByTransactionId(String transactionId);
}
