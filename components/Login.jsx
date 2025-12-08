'use client'

import React, {useEffect, useState} from 'react'
import { Fugaz_One } from 'next/font/google'
import Button from './Button'
import { useAuth } from '@/context/authContext'

const fugaz = Fugaz_One({ subsets: ["latin"], weight: ['400'] })

const Login = () => {
  const [email, setEmail] = useState('')
  const [password, setPassword] = useState('')
  const [isRegister, setIsRegister] = useState(false)
  const [authenticating, setAuthenticating] = useState(false)
  const [error, setError] = useState('')

  const { signup, login } = useAuth()

  async function handleSubmit(params) {
    if(!email || !password || password.length < 6){
      setError('Please enter a valid email and password (minimum 6 characters)')
      return
    }

    setAuthenticating(true)
    setError('')
    try {
      if(isRegister){
        console.log("Signing Up a Nwe User")
        await signup(email, password)
      }
      else {
        console.log("Logging in existing User")
        await login(email, password)
      }
    } catch (error) {
        console.log(error.message)
        // Handle different Firebase auth errors
        if (error.code === 'auth/user-not-found') {
          setError('No user found with this email address')
        } else if (error.code === 'auth/wrong-password') {
          setError('Incorrect password. Please try again')
        } else if (error.code === 'auth/invalid-email') {
          setError('Invalid email address')
        } else if (error.code === 'auth/email-already-in-use') {
          setError('This email is already registered')
        } else if (error.code === 'auth/weak-password') {
          setError('Password should be at least 6 characters')
        } else if (error.code === 'auth/invalid-credential') {
          setError('Invalid email or password. Please check your credentials')
        } else {
          setError('Authentication failed. Please try again')
        }
    } finally {
      setAuthenticating(false)
    }
  }

  return (
    <div className='flex flex-col flex-1 justify-center items-center gap-4'>
      <h3 className={`text-4xl sm:text-5xl md:text-6xl ${fugaz.className}`}>{isRegister ? 'Register' : 'Log In'}</h3>
      <p>You're one step away!</p>
      <input value={email} onChange={(e) => {
        setEmail(e.target.value)
      }} className='hover:border-indigo-600 focus:border-indigo-600 w-full max-w-[400px] mx-auto px-3 py-2 sm:py-3 border border-solid border-indigo-400 rounded-full outline-none'
        placeholder='Email...'
      />
      <input value={password} onChange={(e) => {
        setPassword(e.target.value)
      }} className='hover:border-indigo-600 focus:border-indigo-600 w-full max-w-[400px] mx-auto px-3 py-2 sm:py-3 border border-solid border-indigo-400 rounded-full outline-none' 
        placeholder='Password...' type='password'/>
      {error && (
        <p className='text-red-500 text-center max-w-[400px] w-full mx-auto'>{error}</p>
      )}
      <div className='max-w-[400px] w-full mx-auto'>
          <Button text={authenticating ? 'Submitting' : 'Submit'} full clickHandler={handleSubmit} />
      </div>
      <p className='text-center'>
        {isRegister ? 'Already have an account? ' : 'Don\'t have an account? '}
        {/* eslint-disable-next-line react/no-unescaped-entities */}
        <button onClick={() => setIsRegister(!isRegister)} className='text-indigo-500'>
          {isRegister ? 'Sign In' : 'Sign Up'}
        </button>
      </p>

    </div>
  )
}

export default Login