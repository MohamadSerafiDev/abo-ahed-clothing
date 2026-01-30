
import React, { useState } from 'react';
import CustomInput from './components/CustomInput';
import { DiamondIcon, MapPinIcon } from './components/Icons';

const App: React.FC = () => {
  const [name, setName] = useState('');
  const [phone, setPhone] = useState('');
  const [address, setAddress] = useState('');
  const [password, setPassword] = useState('');

  const handleSignup = (e: React.FormEvent) => {
    e.preventDefault();
    console.log('Registering with:', { name, phone, address, password });
    // Handle registration logic
  };

  return (
    <div className="min-h-screen bg-white flex flex-col items-center justify-start p-6 md:p-8 max-w-md mx-auto">
      {/* Header / Logo Section */}
      <header className="flex flex-col items-center mt-8 mb-10 w-full">
        <div className="w-16 h-16 rounded-full bg-white border border-gray-100 flex items-center justify-center shadow-sm mb-4">
          <div className="w-12 h-12 rounded-full border border-amber-100 flex items-center justify-center text-amber-500">
            <DiamondIcon className="w-6 h-6 fill-amber-500/20" />
          </div>
        </div>
        <h1 className="text-[#d4af37] text-2xl font-bold tracking-tight mb-8">
          أبو عهد
        </h1>
        
        <div className="text-center">
          <h2 className="text-4xl font-extrabold text-gray-900 mb-3">
            إنشاء حساب
          </h2>
          <p className="text-gray-400 font-medium">
            انضم إلى السوق المتميز للأزياء الحصرية
          </p>
        </div>
      </header>

      {/* Form Section */}
      <form onSubmit={handleSignup} className="w-full space-y-2">
        <CustomInput 
          label="الاسم" 
          placeholder="محمد أحمد" 
          value={name} 
          onChange={setName} 
        />
        
        <CustomInput 
          label="رقم الهاتف" 
          placeholder="+971 50 000 0000" 
          type="tel"
          value={phone} 
          onChange={setPhone} 
        />
        
        <CustomInput 
          label="العنوان" 
          placeholder="الشارع، المدينة، الدولة" 
          icon={<MapPinIcon className="w-5 h-5" />}
          value={address} 
          onChange={setAddress} 
        />
        
        <CustomInput 
          label="كلمة المرور" 
          placeholder="••••••••" 
          isPassword={true}
          value={password} 
          onChange={setPassword} 
        />

        {/* Action Button */}
        <button
          type="submit"
          className="w-full h-[64px] bg-[#d4af37] text-white rounded-xl font-bold text-lg mt-8 active:scale-[0.98] transition-all gold-button-shadow"
        >
          تسجيل
        </button>
      </form>

      {/* Footer Links */}
      <footer className="w-full mt-10 text-center flex flex-col gap-8 pb-10">
        <p className="text-gray-500 font-medium">
          لديك حساب بالفعل؟{' '}
          <button className="text-[#d4af37] font-bold hover:underline">
            تسجيل الدخول
          </button>
        </p>

        <p className="text-xs text-gray-400 leading-relaxed max-w-[280px] mx-auto">
          من خلال إنشاء حساب، فإنك توافق على <br />
          <a href="#" className="underline">شروط الخدمة</a> و <a href="#" className="underline">سياسة الخصوصية</a> في أبو عهد
        </p>
      </footer>
    </div>
  );
};

export default App;
