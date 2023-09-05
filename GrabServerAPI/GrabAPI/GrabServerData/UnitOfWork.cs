﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Transactions;
using GrabServerData;
using GrabServerCore.RepoInterfaces;
using GrabServerData.Repositories;
using AutoMapper;

namespace GrabServerData
{
    public class UnitOfWork
    {
        readonly GrabDataContext _dataContext;
        public UnitOfWork(GrabDataContext dataContext)
        {
            _dataContext = dataContext;
        }

        public async Task<bool> SaveChangesAsync()
        {
            using (var scope = new TransactionScope(TransactionScopeAsyncFlowOption.Enabled))
            {
                try
                {
                    var result = await _dataContext.SaveChangesAsync();
                    scope.Complete();
                    return result > 0;
                }
                catch (Exception)
                {
                    scope.Dispose();
                    return false;
                }
            }
        }


        #region Account
        private IAccountRepo _accountRepo;
        public IAccountRepo AccountRepo
        {
            get
            {
                if (_accountRepo == null)
                    _accountRepo = new AccountRepo(_dataContext);
                return _accountRepo;
            }
        }
        #endregion

        #region Booking
        private IBookingRepo _bookingRepo;
        private IMapper _mapper;
        public IBookingRepo BookingRepo
        {
            get
            {
                if (_bookingRepo == null)
                    _bookingRepo = new BookingRepo(_dataContext,_mapper);
                return _bookingRepo;
            }
        }
        #endregion

        #region Driver
        private IDriverRepo _driverRepo;
        public IDriverRepo DriverRepo
        {
            get
            {
                if (_driverRepo == null)
                    _driverRepo = new DriverRepo(_dataContext);
                return _driverRepo;
            }
        }
        #endregion
        public List<string> SaveChanges()
        {
            var errors = new List<string>();
            try
            {
                _dataContext.SaveChanges();
                return errors;
            }
            catch (Exception ex)
            {
                var currentEx = ex;
                do
                {
                    errors.Add(currentEx.Message);
                    if (currentEx.InnerException == null)
                        break;
                    currentEx = currentEx.InnerException;
                } while (true);
                return errors;
            }
        }
    }
}
